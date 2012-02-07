package Impacto::ControllerBase::CRUD;
use utf8;
use Moose;
use List::Util qw/first reduce/;
use namespace::autoclean;

BEGIN { extends 'Impacto::ControllerBase::Base' }

with 'Impacto::ControllerRole::Forms';

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

has search_namespace => (
    isa     => 'Str',
    is      => 'ro',
    lazy    => 1,
    default => sub {
        my $self = shift;
        my $namespace = $self->action_namespace($self->_app);
        $namespace =~ s#/#-#g;
        return $namespace;
    },
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
sub _build_form_columns_extra_params { +{} }

# in the controller it would be like:
# sub _build_datagrid_columns {
#   return [ qw/ name date special_date_time customer_name custom_width_column / ]
# }
# sub _build_datagrid_columns_extra_params {
#    return {
#       special_date_time   => { format => '%d - %m - %Y' },
#       customer_name       => { fk => 'customer.name' },
#       custom_width_column => { width => '40%' },
#    }
# }
sub _build_datagrid_columns { goto \&_fetch_all_columns }
sub _build_datagrid_columns_extra_params { +{} }

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

    my $item = $c->model('Search')->get_item($self->search_namespace, $id);

    $c->stash(
        id  => $id,
        row => $c->stash->{resultset}->find($item->{_source}{_pks}),
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

    my $source  = $c->stash->{resultset}->result_source;
    my @columns = @{ $self->datagrid_columns };

    my @result = (
        {
            field => '_esid',
            name => 'ID',
        },
        map {
            +{
                field => $_,
                name => $c->loc("crud." . $source->from . ".$_"),
                editable => 0,
                width => 'auto',
            }
        } @columns
    );

    $c->stash(
        template  => 'list.tt2',
        structure => \@result,
        identity  => '_esid',
    );
}

sub list_json_data : Chained('crud_base') PathPart Args(0) {
    my ($self, $c) = @_;
    my @columns = @{ $self->datagrid_columns };

    my $search = $c->model('Search')->search(
        $self->search_namespace
    );

    my @items;

    foreach my $hit (@{ $search->{hits}{hits} }) {
        push @items, {
            _esid => $hit->{_id},
            %{ $hit->{_source} },
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

### -- Private Methods -- ###

# TODO: this is duplicate of Impacto::ControllerRole::Forms
sub _translate_form_field {
    my ($c, $caller, $display_name, $origin_object) = @_;
    return $c->loc('crud.' . $caller->form->name . '.' . $origin_object->name);
}

sub _is_date {
    my $type = shift;

    my @date_types = qw(
        date datetime timestamp
    );

    return first { $_ eq $type } @date_types;
}

__PACKAGE__->meta->make_immutable;

1;
