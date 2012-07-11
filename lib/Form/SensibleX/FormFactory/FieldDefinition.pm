package Form::SensibleX::FormFactory::FieldDefinition;
use Moose;
use Class::Load qw/load_class/;
use Hash::Merge 'merge';
use namespace::autoclean;

has _factory => (
    is => 'ro',
    weak_ref => 1,
);

has delete_definition => (
    isa => 'Bool',
    is => 'rw',
    default => 0,
);

has definition => (
    isa => 'HashRef',
    is  => 'rw',
    default => sub { +{} },
);

has extra_params => (
    is => 'ro',
    isa => 'HashRef',
    default => sub { +{} },
);

has name => (
    is => 'ro',
    isa => 'Str',
);

sub check_field_class {
    my $self = shift;

    if ($self->extra_params->{field_class}) {
        delete $self->definition->{field_type};
    }

    if ($self->extra_params->{x_field_class}) {
        delete $self->definition->{field_type};

        my $x_field_class = delete $self->extra_params->{x_field_class};
        my $field_class   = 'Form::SensibleX::Field::' . $x_field_class;
        $self->definition->{field_class} = '+' . $field_class;

        load_class( $field_class );
    }
}

sub merge_definition {
    my $self       = shift;
    my $definition = merge( $self->extra_params, $self->definition );
    $self->definition($definition);
}

sub check_field_factory {
    my $self = shift;
    my $definition = $self->definition;

    if (!$self->extra_params->{x_field_factory}) {
        return;
    }

    delete $self->definition->{field_type};
    delete $self->definition->{field_class};
    delete $self->definition->{integer_only};

    my $x_field_factory     = delete $self->extra_params->{x_field_factory};
    my $field_factory_class = 'Form::SensibleX::FieldFactory::' . $x_field_factory;

    # FIXME: ->_factory should not exist. fix using Bread::Board
    my $field_factory       = $self->_factory->get_field_factory($field_factory_class);

    if ($field_factory) {
        $definition->{name} = $self->name;
        $field_factory->add_field($definition);
    }
    else {
        load_class( $field_factory_class );

        $definition->{model}   = $self->_factory->model;
        $definition->{request} = $self->_factory->request;
        $definition->{name}    = $self->name;

        $field_factory = $field_factory_class->new( $definition );

        # FIXME: ->_factory should not exist. fix using Bread::Board
        $self->_factory->set_field_factory($field_factory_class, $field_factory);
    }

    $self->delete_definition(1);
}

sub get_definition {
    my $self = shift;

    $self->check_field_class;
    $self->merge_definition;
    $self->check_field_factory;

    return if ($self->delete_definition);

    return $self->definition;
}

__PACKAGE__->meta->make_immutable;

1;

__END__

=encoding utf8

=head1 NAME

Form::SensibleX::FormFactory::FieldDefinition - Builds the definition for a
Form::Sensible field

=head1 DESCRIPTION

This module merges the definition for a given field automatically generated
using the DBIC schema with a hash called extra_params. Also, it is able to use
field factories.

=head1 METHODS

=head2 get_definition

Returns the resulting definition.

=head2 check_field_factory

Checks whether the definition contains a field_factory, so that it should be
removed from the normal FS definition hash, and handed over to the factory.

=head2 check_field_class

Checks whether there is a (x_)?field_class key.

=head2 merge_definition

Actually merges the generated definition with the extra params.

=head1 AUTHOR

André Walker <andre@andrewalker.net>

=head1 LICENSE

This library is free software. You can redistribute it and/or modify it under
the same terms as Perl itself.
