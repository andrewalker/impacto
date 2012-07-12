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
    my ( $self, $args ) = @_;
    my @items;

    my $query = $args->{query}
              ? { text => { _all => $args->{query} } }
              : { match_all => {} }
              ;

    my $sort = _get_sort_array($args->{sort});

    my $search = $self->_es->search(
        index => 'impacto',
        type  => $args->{type},
        sort  => $sort,
        query => $query,
        from  => $args->{start},
        size  => $args->{count},
    );

    foreach my $hit (@{ $search->{hits}{hits} }) {
        my %row = %{ $hit->{_source} };
        delete $row{_pks};
        $row{_esid} = $hit->{_id};
        push @items, \%row;
    }

    return {
        total => $search->{hits}{total},
        items => \@items,
    }
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

sub _get_sort_array {
    my $sort = shift;

    return [ '_score' ] unless $sort;

    my @result = map {
        ( substr($_, 0, 1) eq '-' ) ?
            { substr($_, 1) . '.untouched' => 'desc' } :
            { $_            . '.untouched' => 'asc'  }
    } split /,/, $sort;

    push @result, '_score';

    return \@result;
}

__PACKAGE__->meta->make_immutable;

1;

__END__

=encoding utf8

=head1 NAME

Impacto::Model::Search - Catalyst Search using ElasticSearch

=head1 SYNOPSIS

See L<Impacto>.

=head1 DESCRIPTION

Impacto's Model for searching. Also used for setting up the datagrid, even when
there is no search.

=head1 METHODS

=head2 browse_data

Searches ElasticSearch, and returns the data, sorted and paginated.

=head2 get_pks

Returns a special field in the Elastic search row, which is a hashref with the
real primary keys in the RDBMS.

=head2 get_item

Fetches the row from ElasticSearch.

=head2 index_data

Indexes the row in ElasticSearch.

=head1 SEE ALSO

L<Catalyst::Model::Search::ElasticSearch>

=head1 AUTHOR

André Walker

=head1 LICENSE

This library is free software; you can redistribute it and/or modify it under
the same terms as Perl itself.
