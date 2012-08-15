package Form::SensibleX::Field::DBIC::MightBe;

use Moose;
use namespace::autoclean;

has name      => ( is => 'rw' );
has value     => ( is => 'rw' );

has on_value  => ( default => 1, is => 'ro' );
has off_value => ( default => 0, is => 'ro' );

has resultset => (
    isa      => 'DBIx::Class::ResultSet',
    is       => 'ro',
    required => 1,
);

sub get_values_from_row {
    my ( $self, $row ) = @_;

    return $row->count_related($self->name);
}

__PACKAGE__->meta->make_immutable;

1;

__END__

=encoding utf8

=head1 NAME

Form::SensibleX::Field::DBIC::MightBe

=head1 DESCRIPTION

=head1 METHODS

=head2 get_option_hash_from_records

Given a list of records, it returns them in an arrayref in which all the
elements are in the form:

    {
        name  => $label,
        value => $value,
    }

=head2 get_records_from_db

Searches the database and returns the records.

=head2 options_delegate_get_from_db

Sub-routine handed to Form::Sensible to get the options for the select.

=head2 get_values_from_row

Returns the value for a given row. Useful when there are many columns in the
value.

=head1 AUTHOR

André Walker <andre@andrewalker.net>

=head1 LICENSE

This library is free software. You can redistribute it and/or modify it under
the same terms as Perl itself.
