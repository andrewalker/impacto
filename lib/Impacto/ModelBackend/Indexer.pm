package ElasticSearch::Impacto::Indexer;
use Moose;
use Readonly;
use namespace::autoclean;

has es => (
    isa => 'ElasticSearch',
    is  => 'ro',
);

has index_name => (
    is  => 'ro',
    isa => 'Str',
);

Readonly my %TYPE_MAP = (
    text      => 'string',
    varchar   => 'string',

    datetime  => 'date',
    timestamp => 'date',
    date      => 'date',

    integer   => 'integer',
    float     => 'float',
    money     => 'float',
    double    => 'double',
);

sub _get_type {
    my $data_type = shift;

    return $TYPE_MAP{ $data_type } || 'string'
}

sub _get_properties {
    my ($source, $columns) = @_;
    my %properties;

    foreach my $column (@{ $columns }) {
        my $type = _get_type( $source->column_info($column)->{data_type} );
        $properties{$column} = {
            type   => 'multi_field',
            fields => {
                $column => {
                    type => $type,
                },
                untouched => {
                    type           => $type,
                    index          => 'not_analyzed',
                    include_in_all => 0,
                },
            }
        }
    }

    return \%properties;
}

sub initialize_index {
    my $self = shift;

    my $es    = $self->es;
    my $index = $self->index_name;

    $es->delete_index(
        index          => $index,
        ignore_missing => 1,
    );

    $es->create_index(
        index   => $index,
        settings => {
            analysis => {
                analyzer => {
                    default => {
                        type        => 'brazilian',
                        tokenizer   => 'standard',
                        #char_filter => ['html_strip'],
                        filter      => [qw(standard lowercase stop asciifolding)],
                    }
                }
            }
        },
    );
}

sub initialize_mapping {
    my ($self, $namespace, $properties) = @_;

    my $es    = $self->es;
    my $index = $self->index_name;

    $es->delete_mapping(
        index          => $index,
        type           => $namespace,
        ignore_missing => 1,
    );

    $es->put_mapping(
        index   => $index,
        type    => $namespace,
        mapping => {
            properties => $properties,
        },
    );
}

sub reindex_controller {
    my ($self, $controller) = @_;

    my $search     = $self->es;
    my $namespace  = $controller->elastic_search_pseudo_table;
    my $rs         = $controller->crud_model_instance;

    my $index_name = $self->index_name;
    my $db_search  = $rs->search();

    my $properties = _get_properties(
        $rs->result_source,
        $controller->datagrid_columns
    );

    $self->initialize_mapping( $namespace, $properties );

    while ( my $row = $db_search->next ) {
        $search->index(
            index => $index_name,
            type  => $namespace,
            data  => $controller->get_elastic_search_insert_data($row),
        );
    }

    return $namespace;
}

__PACKAGE__->meta->make_immutable;

1;

__END__

=encoding utf8

=head1 NAME

ElasticSearch::Impacto::Indexer

=head1 AUTHOR

André Walker

=head1 LICENSE

This library is free software; you can redistribute it and/or modify it under
the same terms as Perl itself.
