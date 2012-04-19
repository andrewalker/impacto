package Form::SensibleX::Field::Base::DBICSelect;

use Moose;
use namespace::autoclean;

extends 'Form::Sensible::Field::Select';

has option_label => (
    isa      => 'ArrayRef[Str]',
    is       => 'ro',
    required => 1,
);

has option_label_as => (
    isa      => 'ArrayRef[Str]',
    is       => 'ro',
    lazy     => 1,
    default  => sub {
        [ map { $a = $_; $a =~ s[\.][_]g; $a } @{ shift->option_label } ]
    },
);

has option_label_separator => (
    isa     => 'Str',
    is      => 'ro',
    default => ' - ',
);

has option_value => (
    isa      => 'ArrayRef[Str]',
    is       => 'ro',
    required => 1,
);

has option_sort => (
    isa        => 'Str|ArrayRef[Str]',
    is         => 'ro',
    lazy_build => 1,
);

has option_filter => (
    isa      => 'Str',
    is       => 'ro',
    required => 0,
);

has first_empty_option => (
    isa     => 'Str|Undef',
    is      => 'ro',
    lazy    => 1,
    default => sub {
        my $self = shift;

        return '--' if !$self->required;
    },
);

has dbic_columns => (
    isa        => 'ArrayRef[Str]',
    is         => 'ro',
    lazy_build => 1,
);

has resultset => (
    isa      => 'DBIx::Class::ResultSet',
    is       => 'ro',
    required => 1,
);

sub _default_field_type { 'select' }

sub _build_option_sort { shift->option_label }

# all the columns that will be fetched from dbic
sub _build_dbic_columns {
    my $self = shift;

    # using hash to avoid duplicate columns
    # if it's a foreign key (e.g. person.name)
    # I only want the column (person)
    my %columns = map {
        m[(.*)\.] ? ( $1 => 1 ) : ( $_ => 1 )
    } (@{ $self->option_label }, @{ $self->option_value });

    return [ keys %columns ];
}

around BUILDARGS => sub {
    my $orig  = shift;
    my $class = shift;

    my %args = ref $_[0] && ref $_[0] eq 'HASH' ? %{$_[0]} : @_;

    $args{option_label} = _fix_array_ref(
        $args{option_label} || $args{option_value}
    );
    $args{option_value} = _fix_array_ref(
        $args{option_value} || $args{option_label}
    );

    return $class->$orig(%args);
};

sub get_options_to_search {
    my $self = shift;

    my @labels    = @{ $self->option_label    };
    my @values    = @{ $self->option_value    };
    my @labels_as = @{ $self->option_label_as };

    my %options = (
        columns  => $self->dbic_columns,
        order_by => $self->option_sort,
    );

    my $found = 0;
    my %join;

    for (my $i = 0; $i < scalar @labels; $i++) {
        if ($labels[$i] =~ m[(.*)\.]) {
            if (!$found) {
                @options{ '+select', '+as' } = ( [], [] );
                $found = 1;
            }

            push @{ $options{'+select'} }, $labels[$i];
            push @{ $options{'+as'} },     $labels_as[$i];

            $join{$1} = 1;
        }
    }

    $options{join} = [ keys %join ];

    return \%options;
}

sub get_first_empty_option {
    my $self = shift;

    my $first_option = $self->first_empty_option;

    return $first_option ? ({ name => $first_option }) : ();
}

sub _fix_array_ref {
    my $value_or_label = shift;

    if (my $ref = ref $value_or_label) {
        die "expecting ARRAY ref" if $ref ne 'ARRAY';

        return $value_or_label;
    }

    return [ $value_or_label ];
}

__PACKAGE__->meta->make_immutable;

1;
