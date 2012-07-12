package Form::SensibleX::Field::DBIC::ManyToMany;

use Moose;
use namespace::autoclean;
use Form::Sensible::DelegateConnection;

extends 'Form::SensibleX::Field::Base::DBICSelect';

has '+options_delegate' => (
    default => sub { FSConnector( \&options_delegate_get_from_db ) },
);

has '+accepts_multiple' => (
    default => 1
);

sub BUILD {
    my $self = shift;
    $self->render_hints->{render_as} = 'checkboxes';
}

sub get_rs {
    my ( $self, $row ) = @_;

    my $name     = $self->name;
    my $accessor = "${name}_rs";

    if (!$row) {
        $row = $self->resultset->new_result({});
        return $row->$accessor->result_source->resultset;
    }

    return $row->$accessor;
}

sub get_records_from_db {
    my ( $self, $row ) = @_;

    my $rs = $self->get_rs($row);

    return [
        $rs->search(
            $self->option_filter,
            $self->get_options_to_search
        )->all
    ];
}

sub options_delegate_get_from_db {
    my $self = shift;

    return $self->get_option_hash_from_records(
        $self->get_records_from_db
    );
}

sub get_option_hash_from_records {
    my ($self, $records) = @_;

    my $sep     = $self->option_label_separator;
    my $name    = $self->option_label_as;
    my $value   = $self->option_value;

    return [
        map {
            {
                name  => $_->concat_columns( $name,  $sep ),
                value => _encode_value( $_, $value ),
            }
        } @$records
    ];
}

sub get_values_from_row {
    my ( $self, $row ) = @_;

    my $value   = $self->option_value;
    my $records = $self->get_records_from_db($row);

    return [ map { _encode_value( $_, $value ) } @$records ];
}

sub _encode_value {
    my ($row, $value) = @_;

    return $row->get_column( $value->[0] )
        if scalar @$value == 1;
}

__PACKAGE__->meta->make_immutable;

1;

__END__

=encoding utf8

=head1 NAME

Form::SensibleX::Field::DBIC::BelongsTo - Foreign keys in Form::Sensible

=head1 DESCRIPTION

=head1 METHODS

=head2 get_rs

Returns the resultset to the many_to_many accessor that DBIC creates.

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

=head2 _encode_value

Encodes multiple columns for a value.

=head1 AUTHOR

André Walker <andre@andrewalker.net>

=head1 LICENSE

This library is free software. You can redistribute it and/or modify it under
the same terms as Perl itself.
