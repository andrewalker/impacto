package Form::SensibleX::FieldFactory::DBIC::ManyToMany;

use Moose;
use namespace::autoclean;
use Form::Sensible::DelegateConnection;
use Form::SensibleX::Field::DBIC::ManyToMany;

has fields => (
    is      => 'ro',
    isa     => 'ArrayRef[Form::SensibleX::Field::DBIC::ManyToMany]',
    default => sub { [] },
    traits  => ['Array'],
    handles => {
        push_field => 'push',
        field_count => 'count',
    }
);

around BUILDARGS => sub {
    my $orig  = shift;
    my $class = shift;

    my %field_args = ref $_[0] && ref $_[0] eq 'HASH' ? %{$_[0]} : @_;
    my %args;

    $field_args{resultset} = $field_args{model}->resultset if $field_args{model};
    delete $field_args{model};
    delete $field_args{request};

    $args{fields} = [ Form::SensibleX::Field::DBIC::ManyToMany->new(%field_args) ];
    $args{fields}->[0]->{from_factory} = __PACKAGE__;

    return $class->$orig(%args);
};

sub add_field {
    my ( $self, $args ) = @_;

    my $field = Form::SensibleX::Field::DBIC::ManyToMany->new($args)
    $field->{from_factory} = __PACKAGE__;
    $self->push_field($field);

    return 1;
}

# form extra params:
# categories => { x_field_factory => 'DBIC::ManyToMany', option_label => 'name', option_value => 'id' }

sub prepare_execute { 1 }

sub execute {
    my ( $self, $row, $fields ) = @_;
    my $i = 0;

    foreach my $keys (values %$fields) {
        my $name    = $self->fields->[$i]->name;
        my $setter  = "set_${name}";
        my $rs      = $self->fields->[$i]->get_rs;

        my @records = map { $rs->find($_) } @$keys;

        $row->$setter(\@records);
        $i++;
    }

    return $i > 0;
}


sub get_values_from_row {
    my ( $self, $row, $fields ) = @_;

# FIXME:
# i'm ignoring $fields

    return {
        map { $self->fields->[$_]->name => $self->fields->[$_]->get_values_from_row($row) } 0..($self->field_count-1)
    };
}

sub build_fields {
    my $self = shift;

    return map { [ $self->fields->[$_], $self->fields->[$_]->name ] } 0..($self->field_count-1);
}

__PACKAGE__->meta->make_immutable;

1;
