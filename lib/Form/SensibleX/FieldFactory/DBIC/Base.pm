package Form::SensibleX::FieldFactory::DBIC::Base;

use Moose;
use namespace::autoclean;

has names => (
    is      => 'ro',
    isa     => 'ArrayRef[Str]',
    default => sub { [] },
    traits  => ['Array'],
    handles => {
        add_name => 'push',
    }
);

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

# didn't add anything
sub add_field { 0 }

# maybe there's nothing to execute
sub execute { 1 }

# or nothing to prepare
sub prepare_execute { 1 }

sub get_values_from_row {
    my ( $self, $row, $fields ) = @_;

    my %field_table     = map  { $_ => 1                      } @$fields;
    my @filtered_fields = grep { $field_table{ $_->{_fname} } } @{ $self->fields };

    return {
        map { $_->name => $_->get_values_from_row($row) } @filtered_fields
    };
}

sub build_fields {
    my ($self, $name) = @_;

    my @filtered_fields = grep { $_->{_fname} eq $name } @{ $self->fields };

    return [ map { [ $_, $_->name ] } @filtered_fields ];
}

__PACKAGE__->meta->make_immutable;

1;

__END__

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

=head2 build_fields

When creating the form, return the fields in memory.

=head1 AUTHOR

André Walker <andre@andrewalker.net>

=head1 LICENSE

This library is free software. You can redistribute it and/or modify it under
the same terms as Perl itself.
