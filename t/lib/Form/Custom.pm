package Form::Custom;
use Moose;
use namespace::autoclean;

sub crud_model_name { 'Product' }

with 'Role::CrudModelInstance';
with 'Role::I18N';
with 'Impacto::ControllerRole::Form' => { -excludes => 'get_all_columns' };

sub _build_form_templates_paths { [''] }

sub _build_form_columns { [ qw/id name supplier cost/ ] }
sub _build_form_columns_extra_params { { supplier => { field_class => 'Select', label_column => 'person', value_column => 'person' } } }

1;
