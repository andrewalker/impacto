package Impacto::ControllerRole::Form;
use utf8;
use Form::Sensible;
use Form::Sensible::Reflector::DBIC;
use Form::Sensible::Renderer::HTML;
use Form::Sensible::DelegateConnection;
use Moose::Role;
use namespace::autoclean;

has form_columns => (
    isa        => 'ArrayRef',
    is         => 'ro',
    lazy_build => 1,
);

has form_columns_extra_params => (
    isa        => 'HashRef',
    is         => 'ro',
    lazy_build => 1,
);

has form_templates_paths => (
    isa        => 'Str',
    is         => 'ro',
    lazy_build => 1,
);


sub _build_form_templates_paths {
    my $self = shift;

    return [ $self->_app->path_to(qw/root templates forms/)->stringify ];
}

# in the controller it would be like:
# sub _build_form_columns {
#   return [ qw/ name date long_text_field foreign_key_field / ]
# }
# sub _build_form_columns_extra_params {
#   return {
#       long_text_field   => { type => 'TextArea' },
#       foreign_key_field => { type => 'Select', label_column => 'name', value_column => 'id' },
#   }
# }
sub _build_form_columns { shift->get_all_columns(@_) }
sub _build_form_columns_extra_params { +{} }

sub build_form {
    my $self = shift;

    my $resultset = $self->crud_model_instance;
    my $source    = $resultset->result_source;

    my $form_options = {
        form => { name => $source->from },
        with_trigger => 1,
    };
    $form_options->{fieldname_filter} = sub {
        @{ $self->form_columns }
    };

    my $reflector = Form::Sensible::Reflector::DBIC->new();

    # TODO: this probably shouldn't be here
    $reflector->field_type_map->{text}->{defaults}->{field_class} = 'Text';
    $reflector->field_type_map->{boolean} = {
        defaults => { field_class => 'Toggle' },
    };

    return $reflector->reflect_from($resultset, $form_options);
}

sub render_form {
    my ( $self, $form ) = @_;

    my $fs_renderer = Form::Sensible::Renderer::HTML->new({
        additional_include_paths => $self->form_templates_paths,
    });

    my $rendered_form = $fs_renderer->render( $form );
    $rendered_form->display_name_delegate(
        FSConnector(  sub { $self->_translate_form_field(@_) }  )
    );

    return $rendered_form->complete;
}

sub submit_form {
    my ($self, $form, $row, $action) = @_;

    my $result = $form->validate();

    return 0 if (! $result->is_valid);

    my $values = $form->get_all_values();
    delete $values->{submit};

    my $submit_form_action = "submit_form_$action";

    $self->$submit_form_action($row, $values);

    return 1;
}

sub submit_form_create {
    my ( $self, $row, $values ) = @_;

    $row->set_columns( $values );
    $row->insert;
}

sub submit_form_update {
    my ( $self, $row, $values ) = @_;
    $row->update( $values );
}

sub _translate_form_field {
    my ($self, $caller, $display_name, $origin_object) = @_;
    return $self->loc('crud.' . $caller->form->name . '.' . $origin_object->name);
}

1;
