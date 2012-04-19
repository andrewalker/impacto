package Form::SensibleX::Field::DBIC::BelongsTo;

use Moose;
use namespace::autoclean;
use Form::Sensible::DelegateConnection;
use MIME::Base64 qw/encode_base64url/;
use JSON;

extends 'Form::SensibleX::Field::Base::DBICSelect';

has '+options_delegate' => (
    default => sub { FSConnector( \&options_delegate_get_from_db ) },
);

sub x_field_dependencies { [ 'model' ] }

around BUILDARGS => sub {
    my $orig  = shift;
    my $class = shift;

    my %args  = @_;

    $args{resultset} = $args{model}->related_resultset( $args{name} )
        if $args{model} && !$args{resultset};
    delete $args{model};

    return $class->$orig(%args);
};

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

    return $row->get_column( $value->[0] )
        if scalar @$value == 1;

# ok, ok. this is madness.
    return encode_base64url(
        encode_json([ map { $row->get_column($_) } @$value ])
    );
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

    if (@{ $self->option_value } == 1) {
        return $raw_value;
    }

    my %values;
    my $decoded_values = decode_json( decode_base64url($raw_value) );
    for (@{ $self->option_value }) {
        $values{$_} = shift @$decoded_values;
    }

    return \%values;
};

__PACKAGE__->meta->make_immutable;

1;
