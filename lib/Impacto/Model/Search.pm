package Impacto::Model::Search;
use Moose;
use namespace::autoclean;
extends 'Catalyst::Model::Search::ElasticSearch';

__PACKAGE__->config(
    transport    => 'http',
    servers      => 'localhost:9200',
    timeout      => 30,
    max_requests => 10_000,
);

sub index_data {
    my ( $self, $type, $data, $id ) = @_;

    if ( $id ) {
        $self->_es->delete(
            index => 'impacto',
            type  => $type,
            id    => $id
        );
    }

    return $self->_es->index(
        index => 'impacto',
        type  => $type,
        data  => $data,
    );
}

sub browse_data {
    my ( $self, $type ) = @_;
    my @items;

    my $search = $self->_es->search(
        index  => 'impacto',
        type   => $type,
        query => {
            match_all => {}
        }
    );

    foreach my $hit (@{ $search->{hits}{hits} }) {
        my %row = %{ $hit->{_source} };
        delete $row{_pks};
        $row{_esid} = $hit->{_id};
        push @items, \%row;
    }

    return \@items;
}

sub get_item {
    my ( $self, $type, $id ) = @_;

    return $self->_es->get(
        index  => 'impacto',
        type   => $type,
        id     => $id,
    );
}

sub get_pks {
    my ( $self, $type, $id ) = @_;

    return $self->get_item($type, $id)->{_source}{_pks};
}

__PACKAGE__->meta->make_immutable;

1;
