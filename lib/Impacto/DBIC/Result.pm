package Impacto::DBIC::Result;

use Moose;
use MooseX::NonMoose;
use List::Util qw/first reduce/;
use namespace::autoclean;
extends 'DBIx::Class::Core';

sub concat_columns {
    my ( $self, $columns, $sep ) = @_;

    return join $sep, map { $self->get_column($_) } @$columns;
}

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

            $data{$column} = $self->$column->strftime( $format );
        }
        elsif (my $fk = $column_params->{fk}) {
            my @items      = split /\./, $fk;
            $data{$column} = reduce { $a->$b } $self, @items;
        }
        else {
            $data{$column} = $self->get_column($column);
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

__END__

=encoding utf8

=head1 NAME

Impacto::DBIC::Result - DBIC Result base classes

=head1 DESCRIPTION

All result classes in the Schema extend from this class.

=head1 METHODS

=head2 get_elastic_search_insert_data

Returns a hashref for inserting this row into ElasticSearch.

=head2 concat_columns

Concatenates given columns using a given separator.

=head1 SEE ALSO

L<Impacto>, L<DBIx::Class::Core>

=head1 AUTHOR

André Walker

=head1 LICENSE

This library is free software. You can redistribute it and/or modify
it under the same terms as Perl itself.
