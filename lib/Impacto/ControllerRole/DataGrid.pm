package Impacto::ControllerRole::DataGrid;
use utf8;
use Moose::Role;
use namespace::autoclean;

has datagrid_columns => (
    isa        => 'ArrayRef',
    is         => 'ro',
    lazy_build => 1,
);

has datagrid_columns_extra_params => (
    isa        => 'HashRef',
    is         => 'ro',
    lazy_build => 1,
);

requires 'crud_model_instance';

# in the controller it would be like:
# sub _build_datagrid_columns {
#   return [ qw/ name date special_date_time customer_name custom_width_column / ]
# }
# sub _build_datagrid_columns_extra_params {
#    return {
#       special_date_time   => { format => '%d - %m - %Y' },
#       customer_name       => { fk => 'customer.name' },
#       custom_width_column => { width => '40%' },
#    }
# }
sub _build_datagrid_columns { shift->get_all_columns(@_) }
sub _build_datagrid_columns_extra_params { +{} }

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
                name => $self->i18n->maketext("crud." . $from . ".$_"),
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
