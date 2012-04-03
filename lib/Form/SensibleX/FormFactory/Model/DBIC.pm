package Form::SensibleX::FormFactory::Model::DBIC;
use Moose;
use Impacto::Form::Sensible::Reflector::DBIC;
use Hash::Merge qw(merge);
use namespace::autoclean;

has _factory => (
    isa      => 'Form::SensibleX::FormFactory',
    is       => 'rw',
    weak_ref => 1,
);

has row => (
    isa => 'DBIx::Class::Row',
    is  => 'ro',
);

has resultset => (
    isa => 'DBIx::Class::ResultSet',
    is  => 'ro',
);

around BUILDARGS => sub {
    my $orig = shift;
    my $self = shift;

    my $args = ref $_[0] && ref $_[0] eq 'HASH' ? $_[0] : {@_};
    $args->{row} ||= $args->{resultset}->new_result({});

    return $self->$orig($args);
};

sub reflect {
    my ( $self, $columns ) = @_;

    my $source    = $self->resultset->result_source;
    my $reflector = Impacto::Form::Sensible::Reflector::DBIC->new();

    my $form_options = {
        form             => { name => $source->from },
        with_trigger     => 1,
        fieldname_filter => sub { @{ $columns } },
    };

    return $reflector->reflect_from($self->resultset, $form_options);
}

sub set_values_from_row {
    my ( $self, $form ) = @_;

    $form->set_values({ $self->get_db_values_from_row( $form ) });

}

sub related_resultset {
    my ( $self, $field ) = @_;
    return $self->resultset->result_source->related_source( $field )->resultset;
}

sub execute {
    my ($self, $form, $action) = @_;

    my $validation = $form->validate();

    return 0 if (! $validation->is_valid);

    my ($values, $field_factories) = $self->get_db_values_and_factories_from_form($form);

    my $execute_action = "execute_$action";

    my $result = $self->$execute_action($values);

    for my $field_factory_class (keys %$field_factories) {
        return 0 if !$result;
        my $obj = $self->_factory->get_field_factory($field_factory_class);
        $result = $obj->execute($field_factories->{$field_factory_class});
    }

    return $result;
}

sub execute_create {
    my ( $self, $values ) = @_;

    $self->row->set_columns( $values );
    $self->row->insert;

    return 1;
}

sub execute_update {
    my ( $self, $values ) = @_;

    $self->row->update( $values );

    return 1;
}

sub get_db_values_from_row {
    my ($self, $form) = @_;

    my $values    = {};
    my $factories = {};

    for my $fieldname ( $form->fieldnames ) {
        my $field   = $form->field($fieldname);
        my $factory = $field->{from_factory};

        next if $field->field_type eq 'trigger';

        if (defined $factory) {
            $factories->{$factory} ||= [];
            push @{ $factories->{$factory} }, $fieldname;
        }
        else {
            $values->{$fieldname} = $self->row->get_column($fieldname);
        }
    }

    return merge( $values, $self->_get_db_factory_values_from_row($factories) );
}

sub _get_db_factory_values_from_row {
    my ($self, $factories) = @_;

    my @values;

    for my $factory (keys %$factories) {
        my $ff = $self->_factory->get_field_factory($factory);
        push @values, %{
            $ff->get_values_from_row( $factories->{$factory} )
        };
    }

    return { @values };
}

sub get_db_values_and_factories_from_form {
    my ($self, $form) = @_;

    my $values    = {};
    my $factories = {};

    for my $fieldname ( $form->fieldnames ) {
        my $field   = $form->field($fieldname);
        my $value   = $field->value();
        my $factory = $field->{from_factory};

        next if defined $value && $value eq '';
        next if $field->field_type eq 'trigger';

        if (defined $factory) {
            $factories->{$factory} ||= {};
            $factories->{$factory}{$fieldname} = $value;
        }
        else {
            $values->{$fieldname} = $value;
        }
    }

    return ($values, $factories);
}

__PACKAGE__->meta->make_immutable;

1;
