package Form::SensibleX::Field::ForeignKey::DBIC;

use Moose;
use namespace::autoclean;
use Form::Sensible::DelegateConnection;
#use MIME::Base64 qw/encode_base64url/;
#use JSON;

extends 'Form::Sensible::Field::Base::DBICSelect';

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
#    return encode_base64url(
#        encode_json([ map { $row->get_column($_) } @$value ])
#    );
}

__PACKAGE__->meta->make_immutable;

1;
