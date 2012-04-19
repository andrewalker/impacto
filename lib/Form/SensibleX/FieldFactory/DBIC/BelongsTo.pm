package Form::SensibleX::FieldFactory::DBIC::BelongsTo;

use Moose;
use namespace::autoclean;
use Form::Sensible::DelegateConnection;
use Form::SensibleX::Field::DBIC::BelongsTo;

has field => ( is => 'ro', isa => 'Form::SensibleX::Field::DBIC::BelongsTo' );

around BUILDARGS => sub {
    my $orig  = shift;
    my $class = shift;

    my %field_args = ref $_[0] && ref $_[0] eq 'HASH' ? %{$_[0]} : @_;
    my %args;

    $field_args{resultset} = $field_args{model}->resultset if $field_args{model};
    delete $field_args{model};
    delete $field_args{request};

    $args{field} = Form::SensibleX::Field::DBIC::BelongsTo->new(%field_args);
    $args{field}{from_factory} = __PACKAGE__;

    return $class->$orig(%args);
};

# form extra params:
# categories => { x_field_factory => 'DBIC::ManyToMany', option_label => 'name', option_value => 'id' }

sub execute { 1 }

sub prepare_execute {
    my ( $self, $row, $fields ) = @_;

    die "multiple fields are not supported in this factory"
        if keys %$fields > 1;

    my $keys    = (values %$fields)[0];

    my $value   = $self->field->value;
    if (ref $value) {
        for my $k (keys %$value) {
            $row->set_column($k => $value->{$k});
        }
    }
    else {
        $row->set_column($self->field->name => $value);
    }

    return 1;
}

sub get_values_from_row {
    my ( $self, $row, $fields ) = @_;

    die "multiple fields are not supported in this factory"
        if scalar @$fields > 1;

    return { $fields->[0] => $self->field->get_values_from_row($row) };
}

sub build_fields {
    my $self = shift;

    return (
        [ $self->field, $self->field->name ]
    );
}

__PACKAGE__->meta->make_immutable;

1;
