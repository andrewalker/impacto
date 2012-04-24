package Form::SensibleX::FieldFactory::DBIC::RecordMeta;

use Moose;
use namespace::autoclean;
use Form::Sensible::Field::Text;

extends 'Form::SensibleX::FieldFactory::DBIC::Base';

# form extra params:
# meta_fields => { x_field_factory => 'RecordMeta', custom_field_name => 'name', custom_field_value => 'value' }

has resultset          => ( is => 'ro' );

has related_resultset => (
    is => 'ro',
    isa => 'ArrayRef',
    default => sub { [] },
    traits  => ['Array'],
    handles => {
        add_related_resultset  => 'push',
    }
);

has field_names => (
    is => 'ro',
    isa => 'ArrayRef[Str]',
    default => sub { [] },
    traits  => ['Array'],
    handles => {
        add_field_name  => 'push',
    }
);

has field_values => (
    is => 'ro',
    isa => 'ArrayRef[Str]',
    default => sub { [] },
    traits  => ['Array'],
    handles => {
        add_field_value  => 'push',
    }
);

around field_count => sub {
    my $orig = shift;
    my $self = shift;

    return $self->$orig(@_) / 2;
};

around BUILDARGS => sub {
    my $orig  = shift;
    my $class = shift;

    my %args  = ref $_[0] && ref $_[0] eq 'HASH' ? %{$_[0]} : @_;


    my $rel   = delete $args{name};
    my $i     = 0;
    my $rs    = $args{model}->resultset || $args{resultset};
    my $rrs   = $rs->result_source->related_source($rel)->resultset;
    my $name  = delete $args{custom_field_name};
    my $value = delete $args{custom_field_value};

    $args{resultset}         = $rs;
    $args{related_resultset} = [ $rrs ];
    delete $args{model};
    delete $args{request};
    my $search = $rrs->search(undef, {
        columns => [ $name ],
        distinct => 1
    });
    my @fields;

    foreach ($search->all) {
        push @fields, _create_field(
            $rel, $name, $i
        );
        push @fields, _create_field(
            $rel, $value, $i
        );

        $i++;
    }

    $args{field_values}  = [ $value ];
    $args{field_names}   = [ $name  ];
    $args{names}         = [ $rel   ];

    $args{fields} = \@fields;

    return $class->$orig(%args);
};

sub _create_field {
    my ($rel, $field, $i, $value) = @_;

    my $name = join '_', ($rel, $field, $i);

    my @args = (name => $name, display_name => $name);
    if ($value) {
        push @args, (value => $value);
    }

    my $obj = Form::Sensible::Field::Text->new(@args);

    $obj->{from_factory} = __PACKAGE__;
    $obj->{_fname}       = $rel;

    return $obj;
}

sub add_field {
    my ( $self, $args ) = @_;

    my $name   = delete $args->{custom_field_name};
    my $value  = delete $args->{custom_field_value};
    my $rel    = $args->{name};
    my $rrs    = $self->resultset->result_source->related_source($rel)->resultset;
    my $count  = $self->field_count;
    my $search = $rrs->search(undef, {
        columns => [ $name ],
        distinct => 1
    });

    $self->add_name( $rel );
    $self->add_related_resultset( $rrs );
    $self->add_field_name(  $name  );
    $self->add_field_value( $value );

    foreach ($search->all) {
        my $f1 = _create_field(
            $rel, $name, $count
        );
        my $f2 = _create_field(
            $rel, $value, $count
        );
        $self->_add_field($f1);
        $self->_add_field($f2);
        $count++;
    }

    return 1;
}

sub get_values_from_row {
    my ( $self, $row, $fields ) = @_;

    return {};
}

__PACKAGE__->meta->make_immutable;

1;
