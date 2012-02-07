package Impacto::ControllerRole::Forms;
use utf8;
use Form::Sensible;
use Form::Sensible::Reflector::DBIC;
use Form::Sensible::Renderer::HTML;
use Form::Sensible::DelegateConnection;
use Moose::Role;
use namespace::autoclean;

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
    my ( $self, $c, $form ) = @_;

    my $fs_renderer = Form::Sensible::Renderer::HTML->new({
        additional_include_paths => [
            $c->path_to(qw/root templates forms/)->stringify
        ],
    });

    my $rendered_form = $fs_renderer->render( $form );
    $rendered_form->display_name_delegate(
        FSConnector(  sub { _translate_form_field($c, @_) }  )
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

# TODO: this is duplicate of Impacto::ControllerBase::CRUD
sub _translate_form_field {
    my ($c, $caller, $display_name, $origin_object) = @_;
    return $c->loc('crud.' . $caller->form->name . '.' . $origin_object->name);
}

1;
