package Form::SensibleX::Field::DBIC::BelongsTo;

use Moose;
use namespace::autoclean;
use Form::Sensible::DelegateConnection;
use MIME::Base64 qw/encode_base64url decode_base64url/;
use JSON;

extends 'Form::SensibleX::Field::Base::DBICSelect';

has '+options_delegate' => (
    default => sub { FSConnector( \&options_delegate_get_from_db ) },
);

sub get_records_from_db {
    my $self = shift;

    return [
        $self->resultset->search(
            $self->option_filter,
            $self->get_options_to_search
        )->all
    ];
}

sub options_delegate_get_from_db {
    my $self = shift;

    my $records = $self->get_records_from_db;

    my $sep     = $self->option_label_separator;
    my $name    = $self->option_label_as;
    my $value   = $self->option_value;

    return [
        $self->get_first_empty_option,
        map {
            {
                name  => $_->concat_columns( $name,  $sep ),
                value => _encode_value( $_, $value ),
            }
        } @$records
    ];
}

sub _encode_value {
    my ($row, $value) = @_;

    return '' if !$row; # value is empty

    return $row->get_column( $value->[0] )
        if scalar @$value == 1;

# ok, ok. this is madness.
    return encode_base64url(
        encode_json([ map { $row->get_column($_) } @$value ])
    );
}

sub get_values_from_row {
    my ( $self, $row ) = @_;

    my $value   = $self->option_value;
    my $name    = $self->name;

    return _encode_value( $row->$name, $value );
}

around value => sub {
    my $orig  = shift;
    my $self  = shift;
    my $value = shift;

    if ($value) {
        if (ref $value && ref $value eq 'ARRAY') {
            $value = encode_base64url(
                encode_json($value)
            );
        }

        return $self->$orig( $value );
    }

    my $raw_value = $self->$orig;

    return @{ $self->option_value } == 1
        ? $raw_value
        : $self->get_multi_value($raw_value)
        ;
};

sub get_multi_value {
    my ($self, $raw_value) = @_;
    my %values;
    my $decoded_values = decode_json( decode_base64url($raw_value)  || '[]' );

    for (@{ $self->option_value }) {
        $values{$_} = shift @$decoded_values;
    }

    return \%values;
}

__PACKAGE__->meta->make_immutable;

1;

__END__

=encoding utf8

=head1 NAME

Form::SensibleX::Field::DBIC::BelongsTo - Foreign keys in Form::Sensible

=head1 DESCRIPTION

=head1 METHODS

=head2 get_records_from_db

Searches the database and returns the records.

=head2 options_delegate_get_from_db

Sub-routine handed to Form::Sensible to get the options for the select.

=head2 get_values_from_row

Returns the value for a given row. Useful when there are many columns in the
value.

=head2 get_multi_value

Returns the values encoded.

=head2 _encode_value

Encodes multiple columns for a value.

=head1 AUTHOR

André Walker <andre@andrewalker.net>

=head1 LICENSE

This library is free software. You can redistribute it and/or modify it under
the same terms as Perl itself.
