#!/usr/bin/env perl
use warnings;
use strict;
use FindBin '$Bin';
use lib "$Bin/../lib";
use Impacto;
use Data::Dumper;
use 5.012;

my $c = new Impacto();
my $search = $c->model('Search')->_es;

$search->delete_index(
    index          => 'impacto',
    ignore_missing => 1,
);

$search->create_index(
    index   => 'impacto',
    settings => {
        analysis => {
            analyzer => {
                default => {
                    type        => 'brazilian',
                    tokenizer   => 'standard',
#                    char_filter => ['html_strip'],
                    filter      => [qw(standard lowercase stop asciifolding)],
                }
            }
        }
    },
);

reindex_db();

my %types = (
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

sub get_type {
    my $data_type = shift;

    return $types{ $data_type } || 'string'
}

sub reindex_db {
    foreach my $controller ($c->controllers) {
        $controller = $c->controller($controller);
        next unless $controller->isa('Impacto::ControllerBase::CRUD');

        my $namespace = $controller->action_namespace($c);
        $namespace    =~ s#/#-#g;
        my $rs        = $controller->crud_model_instance;
        my $source    = $rs->result_source;
        my $columns   = $controller->datagrid_columns;

        my %properties;

        foreach my $column (@{ $columns }) {
            $properties{$column} = {
                type => get_type( $source->column_info($column)->{data_type} ),
            }
        }

        my $result = $search->put_mapping(
            index => 'impacto',
            type  => $namespace,
            mapping => {
                properties => \%properties,
            },
        );

        my $db_search = $rs->search();
        while (my $row = $db_search->next) {
            $search->index(
                index => 'impacto',
                type  => $namespace,
                data  => $controller->get_elastic_search_insert_data($row),
            );
        }
        say $namespace;
    }
}
