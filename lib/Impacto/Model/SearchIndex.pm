package Impacto::Model::SearchIndex;
use Moose;
use Readonly;
extends 'Catalyst::Model';
use namespace::autoclean;

Readonly my %type_map = (
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

    return $type_map{ $data_type } || 'string'
}

sub initialize_index {
    my ($self, $search) = @_;

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
                        #char_filter => ['html_strip'],
                        filter      => [qw(standard lowercase stop asciifolding)],
                    }
                }
            }
        },
    );
}

sub _get_properties {
    my ($source, $columns) = @_;
    my %properties;

    foreach my $column (@{ $columns }) {
        my $type = get_type( $source->column_info($column)->{data_type} );
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

sub initialize_mapping {
    my ($self, $search, $namespace, $source, $columns) = @_;

    $search->delete_mapping(
        index          => 'impacto',
        type           => $namespace,
        ignore_missing => 1,
    );

    $search->put_mapping(
        index   => 'impacto',
        type    => $namespace,
        mapping => {
            properties => _get_properties($source, $columns),
        },
    );
}

sub reindex_controller {
    my ($self, $search, $controller) = @_;

    my $namespace = $controller->elastic_search_pseudo_table;
    my $rs        = $controller->crud_model_instance;

    $self->initialize_mapping(
        $search,
        $namespace,
        $rs->result_source,
        $controller->datagrid_columns,
    );

    my $db_search = $rs->search();
    while (my $row = $db_search->next) {
        $search->index(
            index => 'impacto',
            type  => $namespace,
            data  => $controller->get_elastic_search_insert_data($row),
        );
    }

    return $namespace;
}

sub reindex_db {
    my ($self, $search, $c) = @_;

    foreach my $controller ($c->controllers) {
        $controller = $c->controller($controller);
        next unless $controller->isa('Impacto::ControllerBase::CRUD');
        $self->reindex_controller($search, $controller);
    }
}

__PACKAGE__->meta->make_immutable;

1;

__END__

=encoding utf8

=head1 NAME

Impacto::Model::SearchIndex

=head1 SYNOPSIS

See L<Impacto>.

=head1 DESCRIPTION

=head1 METHODS

=head1 SEE ALSO

L<Impacto::Model::Search>

=head1 AUTHOR

André Walker

=head1 LICENSE

This library is free software; you can redistribute it and/or modify it under
the same terms as Perl itself.
