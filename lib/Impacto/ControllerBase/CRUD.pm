package Impacto::ControllerBase::CRUD;
use utf8;
use Form::Sensible;
use Form::Sensible::Reflector::DBIC;
use Form::Sensible::Renderer::HTML;
use Form::Sensible::DelegateConnection;
use Moose;
use namespace::autoclean;

BEGIN { extends 'Impacto::ControllerBase::Base' }

has name => (
    isa        => 'Str',
    is         => 'ro',
    default    => '',
);

has crud_model_name => (
    isa        => 'Str',
    is         => 'ro',
);

has crud_model_instance => (
    isa        => 'DBIx::Class::ResultSet',
    is         => 'rw',
    required   => 0,
);

sub crud_base : Chained('global_base') PathPrefix CaptureArgs(0) {
    my ( $self, $c ) = @_;
    my $rs = $self->crud_model_instance
     || $self->crud_model_instance(
            $c->model( $self->crud_model_name )
        );

    my $form_options = {
        form => { name => $rs->result_source->from },
        with_trigger => 1,
    };
    $form_options->{fieldname_filter} = sub { $self->fieldname_filter(@_) }
        if $self->can('fieldname_filter');

    my $reflector = Form::Sensible::Reflector::DBIC->new();
    $reflector->field_type_map->{text}->{defaults}->{field_class} = 'Text';

    my $form = $reflector->reflect_from($rs, $form_options);

    my $fs_renderer = Form::Sensible::Renderer::HTML->new({
        additional_include_paths => [ $c->path_to(qw/root templates forms/)->stringify ],
    });
    my $rendered_form = $fs_renderer->render($form);
    $rendered_form->display_name_delegate( FSConnector( sub { _translate_display_name($c, @_) } ) );

    $c->stash(
        form      => $form,
        form_html => $rendered_form->complete,
    );
}

sub crud_base_with_id : Chained('crud_base') PathPart('') CaptureArgs(1) {
    my ( $self, $c, $id ) = @_;

    $c->stash(id => $id);
}

sub list      : Chained('crud_base') PathPart Args(0) {}
sub list_json : Chained('crud_base') PathPart Args(0) {}
sub delete    : Chained('crud_base') PathPart Args(0) {}
sub create    : Chained('crud_base') PathPart Args(0) {}

sub edit      : Chained('crud_base_with_id') PathPart Args(0) {}
sub view      : Chained('crud_base_with_id') PathPart Args(0) {}

sub _translate_display_name {
    my ($c, $caller, $display_name, $origin_object) = @_;
    return $c->loc('form.' . $caller->form->name . '.' . $origin_object->name);
    #return $display_name;
}

__PACKAGE__->meta->make_immutable;

1;
