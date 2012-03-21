package Impacto::ControllerBase::CRUD;
use utf8;
use Moose;
use namespace::autoclean;
use Data::Dumper;
use JSON;

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

has i18n => (
    isa => 'Locale::Maketext',
    is  => 'rw',
);

# because 'type' is so mainstream
has elastic_search_pseudo_table => (
    isa     => 'Str',
    is      => 'ro',
    lazy    => 1,
    default => sub {
        my $self = shift;
        my $namespace = $self->action_namespace( $self->_app );
        $namespace =~ s#/#-#g;
        return $namespace;
    },
);

sub _build_crud_model_instance {
    my $self = shift;

    return $self->_application->model(
        $self->crud_model_name
    );
}

# Helper method for datagrid_columns and form_columns,
# which default to all columns.
# Both of them should be overriden by the controller itself,
# i.e. list only the relevant ones, when appropriate
sub get_all_columns {
    my $self = shift;
    return [ $self->crud_model_instance->result_source->columns ];
}

with 'Impacto::ControllerRole::Form',
     'Impacto::ControllerRole::DataGrid';

### -- Actions -- ###
##  -- Beginning of the Chain --  ##

sub crud_base : Chained('global_base') PathPrefix CaptureArgs(0) {
    my ( $self, $c ) = @_;

    $self->i18n( $c->model('Maketext') );

    $c->stash(
        resultset        => $self->crud_model_instance,
        table_prefix_uri => $c->uri_for('/') . $self->path_prefix($c),
        title            => $self->i18n->maketext('page_title.' . $self->crud_model_instance->result_source->from),
    );
}

sub crud_base_with_id : Chained('crud_base') PathPart('') CaptureArgs(1) {
    my ( $self, $c, $id ) = @_;

    my $pks = $c->model('Search')->get_pks($self->elastic_search_pseudo_table, $id);

    $c->stash(
        id  => $id,
        row => $self->crud_model_instance->find( $pks ),
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

sub list : Chained('crud_base') PathPart('') Args(0) {
    my ($self, $c) = @_;

    $c->stash(
        template  => 'list.tt2',
        structure => to_json($self->get_browse_structure()),
        identity  => '_esid',
    );
}

sub list_json_data : Chained('crud_base') PathPart Args(0) {
    my ($self, $c) = @_;

    my $query = $c->req->query_params;

    my $results = $c->model('Search')->browse_data({
        type  => $self->elastic_search_pseudo_table,
        query => $query->{q},
        start => $query->{start},
        count => $query->{count},
        sort  => $query->{sort},
    });

    $c->stash(
        current_view => 'JSON',
        items        => $results->{items},
        numRows      => $results->{total},
    );
}

# TODO
# sub view : Chained('crud_base_with_id') PathPart Args(0) {}

sub delete : Chained('crud_base') PathPart Args(0) {
    my ( $self, $c ) = @_;

    my $response = '';

    foreach my $id (values $c->req->body_params) {
        my $pks = $c->model('Search')->get_pks(
            $self->elastic_search_pseudo_table,
            $id
        );

        $self->crud_model_instance->find($pks)->delete;

        $c->model('Search')->delete(
            index => 'impacto',
            type  => $self->elastic_search_pseudo_table,
            id    => $id
        );

        $response .= "Registro $id removido";
    }
    $c->res->body($response);
}

### -- Helper Methods -- ###

sub make_form_action {
    my ($self, $c, $action) = @_;

    my $form = $self->build_form_sensible_object;
    my $row = $c->stash->{row} ||
        $self->crud_model_instance->new_result({});

    if ($c->req->method eq 'POST') {
        my $values = $c->req->body_params;

        for my $field ($c->req->upload) {
            $values->{$field} = $c->req->upload( $field );
        }

        $form->set_values( $values );

        # TODO
        # this 'if' is wrong
        # if something goes wrong, it should display an error message
        if ( $self->submit_form( $form, $row, $action ) ) {
            $c->model('Search')->index_data(
                $self->elastic_search_pseudo_table,
                $self->get_elastic_search_insert_data( $row ),
                $c->stash->{id},
            );

            return $c->res->redirect( $c->uri_for( $self->action_for( 'list' ) ) );
        }

    }
    elsif ($row) {
        $form->set_values({ $row->get_columns() })
    }

    my $template = $c->view('TT')->get_first_existing_template($c->action, $action);

    $c->stash(
        form      => $form,
        form_html => $self->render_form( $form ),
        template  => $template,
    );
}

__PACKAGE__->meta->make_immutable;

1;

__END__

=head1 NAME

Impacto::ControllerBase::CRUD - Base controller for CRUD classes

=head1 DESCRIPTION

Adds basic create / read / update / delete actions for a given controller, which
has a specific result class (table) associated.
It generates a basic form for creating / updating records (which should be
overridable), and creates a grid to display the data.

=head1 METHODS

=head2 crud_base

The beginning of the chain for every other method in this class.

=head2 crud_base_with_id

The beginning of the chain for those methods which require the id to be given
as an argument (e.g. update, view)

=head2 create

Displays a form to insert a new record into the database. When the form is
submitted, this same method is called.

=head2 update

Displays a form to update an existing record in the database. When the form is
submitted, this same method is called.

=head2 delete

Unimplemented. Deletes a record (maybe multiple?).

=head2 view

Unimplemented. Displays more information about a record.

=head2 list

Displays a page with an HTML table, with 10 records from the database. These
records are fetched using ajax.

=head2 list_json_data

This is called by the list page, by ajax, to populate the HTML table.

=head2 get_all_columns

Helps the builder of datagrid_columns and form_columns attributes, so that
their default values are all the columns in the table.

=head2 make_form_action

All the logic from update and create actions. It decides wether to display or
submit the form, and wether it's an 'update' or a 'create' action.

=head1 AUTHOR

André Walker <andre@andrewalker.net>

=head1 LICENSE

This library is free software. You can redistribute it and/or modify
it under the same terms as Perl itself.
