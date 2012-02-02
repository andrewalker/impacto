package Impacto::ControllerBase::CRUD;
use utf8;
use Form::Sensible;
use Form::Sensible::Reflector::DBIC;
use Form::Sensible::Renderer::HTML;
use Form::Sensible::DelegateConnection;
use Moose;
use namespace::autoclean;

BEGIN { extends 'Impacto::ControllerBase::Base' }

### -- Attributes -- ###

has crud_model_name => (
    isa        => 'Str',
    is         => 'ro',
);

# mainly for caching the persistent object
has crud_model_instance => (
    isa        => 'DBIx::Class::ResultSet',
    is         => 'ro',
    lazy_build => 1,
);

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

##  -- Builders --  ##

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
sub _build_form_columns {     goto \&_fetch_all_columns }

# in the controller it would be like:
# sub _build_datagrid_columns {
#   return [ qw/ name date special_date_time customer_name custom_width_column / ]
# }
# sub _build_datagrid_columns_extra_params {
#    return {
#       special_date_time   => { format => '%d - %m - %Y' },
#       customer_name       => { join => 'customer', select => 'customer.name' },
#       custom_width_column => { width => '40%' },
#    }
# }
sub _build_datagrid_columns { goto \&_fetch_all_columns }

# Helper method for datagrid_columns and form_columns,
# which default to all columns.
# Both of them should be overriden by the controller itself,
# i.e. list only the relevant ones, when appropriate
sub _fetch_all_columns {
    my $self = shift;
    return [ $self->crud_model_instance->result_source->columns ];
}

sub _build_crud_model_instance {
    my $self = shift;

    return $self->_application->model(
        $self->crud_model_name
    );
}

### -- Actions -- ###
##  -- Beginning of the Chain --  ##

sub crud_base : Chained('global_base') PathPrefix CaptureArgs(0) {
    my ( $self, $c ) = @_;

    $c->stash(
        resultset        => $self->crud_model_instance,
        table_prefix_uri => $c->uri_for('/') . $self->path_prefix($c),
    );
}

sub crud_base_with_id : Chained('crud_base') PathPart('') CaptureArgs(1) {
    my ( $self, $c, $id ) = @_;

    $c->stash(
        id  => $id,
        row => $c->stash->{resultset}->find($id),
    );
}

##  -- CRUD --  ##

sub create : Chained('crud_base') PathPart Args(0) {
    my ($self, $c) = @_;

    $self->make_form_action($c, 'create');
}

sub update : Chained('crud_base_with_id') PathPart Args(0) {
    my ($self, $c) = @_;

    $self->make_form_action($c, 'update');
}

# TODO: move to Elastic Search
# and make it more customizable
sub list : Chained('crud_base') PathPart('') Args(0) {
    my ($self, $c) = @_;
    my @result;

    my $source  = $c->stash->{resultset}->result_source;
    my @columns = @{ $self->datagrid_columns };

    for (@columns) {
        push @result, {
            field => $_,

            name => $c->loc("crud." . $source->from . ".$_"),
            editable => 0,
            width => 'auto',
        };
    }

    $c->stash(
        template  => 'list.tt2',
        structure => \@result,

        # TODO: this is useless, it doesn't work as expected
        # gotta move it to ElasticSearch id
        # identity  => join (',', map { "'$_'" } $source->primary_columns),
    );
}

sub list_json_data : Chained('crud_base') PathPart Args(0) {
    my ($self, $c) = @_;
    my @columns = @{ $self->datagrid_columns };

    my $search = $c->stash->{resultset}->search();
    my @items;

    while (my $item = $search->next) {
        push @items, {
            map { $_ => $item->get_column($_) } @columns
        };
    }

    $c->stash(
        current_view => 'JSON',
        items        => \@items,
    );
}

# TODO
# sub view : Chained('crud_base_with_id') PathPart Args(0) {}
# sub delete : Chained('crud_base') PathPart Args(0) {}

### -- Helper Methods -- ###

sub _build_form {
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

sub _submit_form {
    my ($self, $form, $action) = @_;

    my $result = $form->validate();

    return 0 if (! $result->is_valid);

    my $values = $form->get_all_values();
    delete $values->{submit};
    $self->crud_model_instance->$action( $values );
# insert into elasticsearch
# if it's type date
#       $row->date ? $row->date->strftime('%d/%m/%Y') : ''
# if its foreign key... deal with it

#    my %data;
#    for my $column ( @{ $self->datagrid_columns } ) {
#        $data{$column} = $values->{$column};
#    }
#    $search->index(
#        index => 'impacto',
#        type  => $self->action_namespace($c),
#        data  => \%data,
#    );

    return 1;
}

sub _render_form {
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

sub make_form_action {
    my ($self, $c, $action) = @_;

    my $form = $self->_build_form;

    # TODO: make customizations here to the $form ($form->get_fields, etc)
    # using $self->form_columns_extra_params

    if ($c->req->method eq 'POST') {
        $form->set_values( $c->req->body_params );
        $self->_submit_form( $form, $action );
    }
    elsif (my $row = $c->stash->{row}) {
        $form->set_values({ $row->get_columns() })
    }

    my $template = $c->view('TT')->get_first_existing_template($c->action, $action);

    $c->stash(
        form      => $form,
        form_html => $self->_render_form( $c, $form ),
        template  => $template,
    );
}

sub _translate_form_field {
    my ($c, $caller, $display_name, $origin_object) = @_;
    return $c->loc('crud.' . $caller->form->name . '.' . $origin_object->name);
}

__PACKAGE__->meta->make_immutable;

1;
