package DataGrid::Custom;
use Moose;
use namespace::autoclean;

sub crud_model_name { 'Product' }

with 'Role::CrudModelInstance';
with 'Role::I18N';
with 'Impacto::ControllerRole::DataGrid' => { -excludes => 'get_all_columns' };

sub datagrid_columns { [ qw/name supplier cost price/ ] }
sub datagrid_columns_extra_params { { supplier => { fk => 'supplier.person.name' } } }

1;
