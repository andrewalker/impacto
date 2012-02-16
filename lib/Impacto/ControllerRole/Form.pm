package Impacto::ControllerRole::Form;
use utf8;
use Form::Sensible;
use Form::Sensible::Renderer::HTML;
use Form::Sensible::DelegateConnection;
use Impacto::Form::Sensible::Reflector::DBIC;
use Moose::Role;
use namespace::autoclean;

requires 'crud_model_instance', 'i18n';

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
    isa        => 'ArrayRef[Str]',
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
#       long_text_field   => { field_class => 'TextArea' },
#       foreign_key_field => { field_class => 'Select', label_column => 'name', value_column => 'id' },
#       # eventual syntax:
#       # foreign_key_field => { fk => 1, label => '${customer.company} - ${customer.person.name}', value_column => 'id' },
#   }
# }
sub _build_form_columns { shift->get_all_columns(@_) }
sub _build_form_columns_extra_params { +{} }

# just to be sure it exists when needed
sub get_all_columns {
    warn 'Method get_all_columns not found.';
    warn 'You should implement it in the class that uses this role.';

    return [];
}

sub build_form_sensible_object {
    my $self = shift;

    my $resultset = $self->crud_model_instance;
    my $source    = $resultset->result_source;
    my $reflector = Impacto::Form::Sensible::Reflector::DBIC->new();

    my $form_options = {
        form             => { name => $source->from },
        with_trigger     => 1,
        fieldname_filter => sub { @{ $self->form_columns } },
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

    return $self->i18n->maketext(
        'crud.' . $caller->form->name . '.' . $origin_object->name
    );
}

1;

__END__

=head1 NAME

Impacto::ControllerRole::Form

=head1 DESCRIPTION

Builds an HTML form to insert or update rows from the database.

=head1 METHODS

=head2 build_form_sensible_object

Builds a Form::Sensible object based on the DBIx::Class resultset.

=head2 get_all_columns

Makes sure that either this method is overridden by the consumer class, or
it is just not needed (because datagrid_columns don't need it's default value).

=head2 render_form

Renders the Form::Sensible object in HTML.

=head2 submit_form

Prepares the form data to insert a new row into the database, or to update an
existing one.

=head2 submit_form_create

Actually inserts the new row.

=head2 submit_form_update

Actually updates the row.

=head1 AUTHOR

André Walker <andre@andrewalker.net>

=head1 LICENSE

This library is free software. You can redistribute it and/or modify
it under the same terms as Perl itself.
