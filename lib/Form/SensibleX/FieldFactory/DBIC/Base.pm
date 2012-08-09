package Form::SensibleX::FieldFactory::DBIC::Base;

use Moose;
use namespace::autoclean;
use Carp;

has fields => (
    is      => 'ro',
    isa     => 'ArrayRef[Form::Sensible::Field]',
    default => sub { [] },
    traits  => ['Array'],
    handles => {
        _add_field  => 'push',
        field_count => 'count',
    }
);

sub _field_class {}

sub _field_factory_buildargs {
    my $class = shift;
    my %args  = @_;

    my $field_args   = $args{field_args};
    my $factory_args = $args{factory_args};

    delete $field_args->{model};
    delete $field_args->{request};

    $factory_args->{fields} = [
        $class->create_field($field_args)
    ];

    return $factory_args;
}

sub _get_buildargs_args {
    my $class = shift;
    return ref $_[0] && ref $_[0] eq 'HASH' ? %{$_[0]} : @_;
}

sub field_factory_names {
    my $self = shift;

    return [ map { $_->{_ff_name} } @{ $self->fields } ];
}

sub create_field {
    my ($self, $args) = @_;

    my $field_class = $self->_field_class;
    my $class       = ref $self || $self;

    croak "_field_class is not defined for $class"
        unless $field_class;

    my $ff_name = delete $args->{_ff_name};

    my $field = $field_class->new($args);
    $field->{from_factory} = $class;
    $field->{_ff_name}     = $ff_name || $args->{name};

    return $field;
}

sub add_field {
    my ( $self, $args ) = @_;

    my $field = $self->create_field($args);
    $self->_add_field($field);

    return 1;
}

# maybe there's nothing to execute
sub execute { 1 }

# or nothing to prepare
sub prepare_execute { 1 }

# TODO: untested
sub get_values_from_row {
    my ( $self, $row ) = @_;

    return {
        map { $_->name => $_->get_values_from_row($row) } @{ $self->fields }
    };
}

# TODO: untested
sub get_fields_for_factory {
    my ($self, $factory) = @_;

    my @filtered_fields = grep { $_->{_ff_name} eq $factory } @{ $self->fields };

    return \@filtered_fields;
}

__PACKAGE__->meta->make_immutable;

1;

__END__

=encoding utf8

=head1 NAME

Form::SensibleX::FieldFactory::DBIC::Base - Base class for DBIC field factories

=head1 DESCRIPTION

Field factories are classes that build one or more fields to be added to the
form. They are used when there are special conditions that must be specified
when creating the field, or saving them to the database. This is the parent
class with the most common methods.

=head1 METHODS

=head2 prepare_execute

Called on the factory before saving all the other fields to the database. By
default, it does nothing, and returns true (1).

=head2 execute

Called on the factory after saving all the other fields to the database. That
means that the record itself already exists in the database. By default, it
does nothing, and returns true (1).

=head2 get_values_from_row

Loads all the values from the database in the given row object, to fill the
form.

=head2 add_field

Add field to the list of known fields by this factory.

=head2 create_field

Instantiates the Form::Sensible::Field object to be added to the list of known
fields for this factory class.

=head2 get_fields_for_factory

When creating the form, return the fields in memory for a given factory
instance.

=head2 field_factory_names

Returns the list of known factory names for this class. They are, in a way,
instances of the factory, though not as in OOP, not Perl instances. They are
"groups" of fields for a database relation. Usually, a factory name will hold
only one field, but not always.

For example, suppose form to insert blog posts, that can be in one or more
categories. The relation 'categories' could be a factory (and therefore, the
name 'categories' would be listed by this method), but the field names could be
different (for example 'personal_cat', 'perl_cat', etc). (Disclaimer: this is
NOT how L<Form::SensibleX::FieldFactory::DBIC::ManyToMany> works! It's just an
example!)

Also, there could be a field factory 'author', which would be another factory
instance, this time with only one field, with the same name.

=head1 AUTHOR

André Walker <andre@andrewalker.net>

=head1 LICENSE

This library is free software. You can redistribute it and/or modify it under
the same terms as Perl itself.
