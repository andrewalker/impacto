package Form::SensibleX::FormFactory::FieldDefinition;
use Moose;
use Class::Load qw/load_class/;
use Hash::Merge 'merge';
use namespace::autoclean;

has field_factories => (
    is       => 'ro',
    required => 0,
    weak_ref => 1,
);

has definition => (
    isa     => 'HashRef',
    is      => 'rw',
    clearer => 'delete_definition',
    reader  => 'get_definition',
    default => sub { +{} },
);

has extra_params => (
    is       => 'ro',
    isa      => 'HashRef',
    default  => sub { +{} },
    required => 0,
);

has name => (
    is  => 'ro',
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
    my $self            = shift;
    my $definition      = merge( $self->extra_params, $self->definition );
    $definition->{name} = $self->name;

    $self->definition($definition);
}

sub check_field_factory {
    my $self = shift;
    my $definition = $self->definition;

    if ($definition->{x_field_factory}) {
        $definition->{name} = $self->name;
        $self->field_factories->add_to_factory($definition);
        $self->delete_definition();
    }
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
