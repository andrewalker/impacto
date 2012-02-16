package Form::Custom;
use Moose;
use namespace::autoclean;

sub crud_model_name { 'Product' }

with 'Role::CrudModelInstance';
with 'Role::I18N';
with 'Impacto::ControllerRole::Form' => { -excludes => 'get_all_columns' };

sub _build_form_templates_paths { [''] }

sub _build_form_columns { [ qw/id name supplier cost/ ] }
sub _build_form_columns_extra_params {
    return {
        name => {
            field_class => 'LongText',
        },
        supplier => {
            fk    => 1,
            label => 'person.name',
            value => 'person',
        },
    };
}

1;
