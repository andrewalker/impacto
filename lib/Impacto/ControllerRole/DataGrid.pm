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
sub _build_datagrid_columns { shift->_fetch_all_columns(@_) }
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
                name => $self->loc("crud." . $from . ".$_"),
                editable => 0,
                width => 'auto',
            }
        } @{ $self->datagrid_columns }
    ];
}

1;
