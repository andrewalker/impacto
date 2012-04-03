package Impacto::ControllerRole::DataGrid;
use utf8;
use Moose::Role;
use namespace::autoclean;

requires 'crud_model_instance', 'i18n';

# in the controller it would be like:
# sub datagrid_columns {
#   return [ qw/ name date special_date_time customer_name custom_width_column / ]
# }
# sub datagrid_columns_extra_params {
#    return {
#       special_date_time   => { format => '%d - %m - %Y' },
#       customer_name       => { fk => 'customer.name' },
#       custom_width_column => { width => '40%' },
#    }
# }
sub datagrid_columns { shift->get_all_columns(@_) }
sub datagrid_columns_extra_params { +{} }

# just to be sure it exists when needed
sub get_all_columns {
    warn 'Method get_all_columns not found.';
    warn 'You should implement it in the class that uses this role.';

    return [];
}

sub get_browse_structure {
    my ( $self ) = @_;

    my $from = $self->crud_model_instance->result_source->from;

    return [
        {
            field => '_esid',
            name => 'ID',
        },
        map {
            +{
                field => $_,
                name => $self->i18n->maketext("crud.$from.$_"),
                editable => 0,
                width => 'auto',
            }
        } @{ $self->datagrid_columns }
    ];
}

sub get_elastic_search_insert_data {
    my ( $self, $row ) = @_;

    return $row->get_elastic_search_insert_data(
        $self->datagrid_columns,
        $self->datagrid_columns_extra_params
    );
}

1;

__END__

=head1 NAME

Impacto::ControllerRole::DataGrid

=head1 DESCRIPTION

Builds an HTML table with rows from the database.

=head1 METHODS

=head2 get_all_columns

Makes sure that either this method is overridden by the consumer class, or
it is just not needed (because datagrid_columns don't need it's default value).

=head2 get_browse_structure

Gets the structure that the HTML table will have, based on the controller
settings, or the defaults from the database.

=head2 get_elastic_search_insert_data

Based on datagrid_columns and datagrid_columns_extra_params attributes, this
method gets information about a row in the database (or about to be inserted),
so that it is inserted in Elastic Search and therefore be easily fetched when
displaying the grid.

=head1 AUTHOR

André Walker <andre@andrewalker.net>

=head1 LICENSE

This library is free software. You can redistribute it and/or modify
it under the same terms as Perl itself.
