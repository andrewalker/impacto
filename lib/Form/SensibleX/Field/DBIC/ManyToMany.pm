package Form::SensibleX::Field::DBIC::ManyToMany;

use Moose;
use namespace::autoclean;
use Form::Sensible::DelegateConnection;
use List::Util qw(first);

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

sub execute_search_db {
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
        $self->execute_search_db
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
    my $records = $self->execute_search_db($row);

    return [ map { _encode_value( $_, $value ) } @$records ];
}

sub _encode_value {
    my ($row, $value) = @_;

    return $row->get_column( $value->[0] )
        if scalar @$value == 1;
}

__PACKAGE__->meta->make_immutable;

1;
