package Impacto::DBIC::Result;

use Moose;
use MooseX::NonMoose;
use List::Util qw/first reduce/;
use namespace::autoclean;
extends 'DBIx::Class::Core';

sub get_elastic_search_insert_data {
    my ($self, $columns, $extra_params) = @_;

    my $source       = $self->result_source;
    my $columns_info = $source->columns_info;

    my %data = (
        _pks => {
            map { $_ => $self->get_column( $_ ) } $source->primary_columns
        }
    );

    for my $column ( @$columns ) {
        my $column_info   = $columns_info->{$column};
        my $column_params = $extra_params->{$column};

        if ( $column_info && _is_date($column_info->{data_type}) ) {
            my $format     = $column_params && $column_params->{format}
                           ? $column_params->{format}
                           : '%d/%m/%Y'
                           ;

            $data{$column} = $row->$column->strftime( $format );
        }
        elsif (my $fk = $column_params->{fk}) {
            my @items      = split /\./, $fk;
            $data{$column} = reduce { $a->$b } $row, @items;
        }
        else {
            $data{$column} = $row->get_column($column);
        }
    }

    return \%data;
}

sub _is_date {
    my $type = shift;

    my @date_types = qw(
        date datetime timestamp
    );

    return first { $_ eq $type } @date_types;
}

__PACKAGE__->meta->make_immutable;

1;
