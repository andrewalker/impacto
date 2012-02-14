package Form::Default;
use Moose;
use namespace::autoclean;

sub crud_model_name { 'Product' }

with 'Role::CrudModelInstance';
with 'Role::I18N';
with 'Impacto::ControllerRole::Form' => { -excludes => 'get_all_columns' };

sub _build_form_templates_paths { [''] }

1;
