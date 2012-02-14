package DataGrid::Default;
use Moose;
use namespace::autoclean;

sub crud_model_name { 'Product' }

with 'Role::CrudModelInstance';
with 'Role::I18N';
with 'Impacto::ControllerRole::DataGrid' => { -excludes => 'get_all_columns' };

1;
