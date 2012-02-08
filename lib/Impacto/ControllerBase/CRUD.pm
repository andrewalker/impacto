package Impacto::ControllerBase::CRUD;
use utf8;
use Moose;
use List::Util qw/first reduce/;
use namespace::autoclean;

BEGIN { extends 'Impacto::ControllerBase::Base' }

with 'Impacto::ControllerRole::Form',
     'Impacto::ControllerRole::DataGrid';

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

# lousy name!
has search_namespace => (
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
sub _fetch_all_columns {
    my $self = shift;
    return [ $self->crud_model_instance->result_source->columns ];
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

    my $pks = $c->model('Search')->get_pks($self->search_namespace, $id);

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
        structure => $self->get_browse_structure,
        identity  => '_esid',
    );
}

sub list_json_data : Chained('crud_base') PathPart Args(0) {
    my ($self, $c) = @_;

    my $items = $c->model('Search')->browse_data(
        $self->search_namespace
    );

    $c->stash(
        current_view => 'JSON',
        items        => $items,
    );
}

# TODO
# sub view : Chained('crud_base_with_id') PathPart Args(0) {}
# sub delete : Chained('crud_base') PathPart Args(0) {}

### -- Helper Methods -- ###

sub make_form_action {
    my ($self, $c, $action) = @_;

    my $form = $self->build_form;
    my $row = $c->stash->{row} ||
        $self->crud_model_instance->new_result({});

    # TODO: make customizations here to the $form ($form->get_fields, etc)
    # using $self->form_columns_extra_params

    if ($c->req->method eq 'POST') {
        $form->set_values( $c->req->body_params );
        $self->submit_form( $form, $row, $action );

        $c->model('Search')->index_data(
            $self->search_namespace,
            $self->get_elastic_search_insert_data( $row ),
            $c->stash->{id},
        );
    }
    elsif ($row) {
        $form->set_values({ $row->get_columns() })
    }

    my $template = $c->view('TT')->get_first_existing_template($c->action, $action);

    $c->stash(
        form      => $form,
        form_html => $self->render_form( $c, $form ),
        template  => $template,
    );
}

# FIXME: should this be in some model? role?
sub get_elastic_search_insert_data {
    my ( $self, $row ) = @_;

    my $columns_info = $row->result_source->columns_info;
    my $extra_params = $self->datagrid_columns_extra_params;

    my %data = (
        _pks => {
            map { $_ => $row->get_column( $_ ) }
                $row->result_source->primary_columns
        }
    );

    for my $column ( @{ $self->datagrid_columns } ) {
        my $column_info   = $columns_info->{$column};
        my $column_params = $extra_params->{$column};

        if ( $column_info && _is_date($column_info->{data_type}) ) {
            my $format     = $column_params && $column_params->{format}
                           ? $column_params->{format}
                           : '%d/%m/%Y'
                           ;

            $data{$column} = $row->$column->strftime( $format );
        }
        elsif (my $fk = $column_params->{fk}) {
            my @items      = split /\./, $fk;
            $data{$column} = reduce { $a->$b } $row, @items;
        }
        else {
            $data{$column} = $row->get_column($column);
        }
    }

    return \%data;
}

sub loc { shift->_app->loc(@_) }

### -- Private Methods -- ###

sub _is_date {
    my $type = shift;

    my @date_types = qw(
        date datetime timestamp
    );

    return first { $_ eq $type } @date_types;
}

__PACKAGE__->meta->make_immutable;

1;
