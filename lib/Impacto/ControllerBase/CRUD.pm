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
    $c->stash(resultset => $rs);
}

sub crud_base_with_id : Chained('crud_base') PathPart('') CaptureArgs(1) {
    my ( $self, $c, $id ) = @_;

    $c->stash(
        id  => $id,
        row => $c->stash->{resultset}->find($id),
    );
}

sub prepare_form {
    my ( $self, $c ) = @_;

    my $source = $c->stash->{resultset}->result_source;

    my $form_options = {
        form => { name => $source->from },
        with_trigger => 1,
    };
    $form_options->{fieldname_filter} = sub {
        $source->fs_field_order(@_)
    } if $source->can('fs_field_order');

    my $reflector = Form::Sensible::Reflector::DBIC->new();
    $reflector->field_type_map->{text}->{defaults}->{field_class} = 'Text';
    $reflector->field_type_map->{boolean} = {
        defaults => { field_class => 'Toggle' },
    };

    my $form = $reflector->reflect_from($c->stash->{resultset}, $form_options);
    $form->set_values({ $c->stash->{row}->get_columns() })
        if exists $c->stash->{row};

    my $fs_renderer = Form::Sensible::Renderer::HTML->new({
        additional_include_paths => [
            $c->path_to(qw/root templates forms/)->stringify
        ],
    });
    my $rendered_form = $fs_renderer->render($form);
    $rendered_form->display_name_delegate( FSConnector( sub { _translate_form_field($c, @_) } ) );

    $c->stash(
        form      => $form,
        form_html => $rendered_form->complete,
    );
}

sub list : Chained('crud_base') PathPart Args(0) {
    my ($self, $c) = @_;
    my $source = $c->stash->{resultset}->result_source;
    my @result;

    for (keys %{ $source->columns_info }) {
        push @result, {
            field => $_,
            name => $c->loc("form." . $source->from . ".$_"),
            editable => 0,
            width => 'auto',
        };
    }

    $c->stash(
        template => 'list.tt2',
        structure => \@result,
    );
}

sub list_json_data : Chained('crud_base') PathPart Args(0) {
    my ($self, $c) = @_;
    my @columns = $c->stash->{resultset}->result_source->columns;
    my $search = $c->stash->{resultset}->search();
    my @items;

    while (my $item = $search->next) {
        push @items, {
            map { $_ => $item->get_column($_) } @columns
        };
    }

    $c->stash(
        current_view => 'JSON',
        items => \@items,
        identifier => 'slug',
    );
}

sub delete : Chained('crud_base') PathPart Args(0) {}

sub create : Chained('crud_base') PathPart Args(0) {
    my ($self, $c) = @_;

    $self->prepare_form($c);

    if ($c->req->method eq 'POST') {
        my $form = $c->stash->{form};
        $form->set_values($c->req->body_params);

        my $result = $form->validate();
        if ($result->is_valid) {
            my $values = $form->get_all_values();
            delete $values->{submit};
            $c->stash->{resultset}->create( $values );
        }
    }

    $c->stash(template => 'create.tt2');
}

sub edit : Chained('crud_base_with_id') PathPart Args(0) {
    my ($self, $c) = @_;
    $self->prepare_form($c);

    if ($c->req->method eq 'POST') {
        my $form = $c->stash->{form};
        $form->set_values($c->req->body_params);

        my $result = $form->validate();
        if ($result->is_valid) {
            my $values = $form->get_all_values();
            delete $values->{submit};
            $c->stash->{row}->update( $values );
        }
    }

    $c->stash(template => 'edit.tt2');
}

sub view : Chained('crud_base_with_id') PathPart Args(0) {}

sub _translate_form_field {
    my ($c, $caller, $display_name, $origin_object) = @_;
    return $c->loc('form.' . $caller->form->name . '.' . $origin_object->name);
}

__PACKAGE__->meta->make_immutable;

1;
