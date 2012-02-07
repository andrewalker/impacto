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
    my ( $self, $type, $data ) = @_;

    return $self->_es->index(
        index => 'impacto',
        type  => $type,
        data  => $data,
    );
}

sub search {
    my ( $self, $type ) = @_;

    return $self->_es->search(
        index  => 'impacto',
        type   => $type,
        query => {
            match_all => {}
        }
    );
}

sub get_item {
    my ( $self, $type, $id ) = @_;

    return $self->_es->get(
        index  => 'impacto',
        type   => $type,
        id     => $id,
    );
}

__PACKAGE__->meta->make_immutable;

1;
