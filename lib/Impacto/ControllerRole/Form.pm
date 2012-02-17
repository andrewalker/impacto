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

has form_sensible_flattened => (
    isa        => 'HashRef|Undef',
    is         => 'rw',
    required   => 0,
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
#       foreign_key_field => { fk => 1, label => 'customer.company', value => 'id', order_by => 'id', filter => { name => 'filtered' } },
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

    # FIXME: use some sort of cache? CHI?
    if (defined $self->form_sensible_flattened) {
        return Form::Sensible->create_form($self->form_sensible_flattened);
    }

    my $resultset = $self->crud_model_instance;
    my $source    = $resultset->result_source;
    my $reflector = Impacto::Form::Sensible::Reflector::DBIC->new();

    my $form_options = {
        form             => { name => $source->from },
        with_trigger     => 1,
        fieldname_filter => sub { @{ $self->form_columns } },
    };

    my $form_definition = $reflector->reflect_from($resultset, $form_options)->flatten;

    my %extra_params = %{ $self->form_columns_extra_params };

    foreach my $field (keys %extra_params) {
        my $fd_field = $form_definition->{fields}{$field};
        my %field_params = %{ $extra_params{$field} };

        if ($field_params{field_class}) {
            delete $fd_field->{field_type};
        }

        if (delete $field_params{fk}) {
            $field_params{related_source} = $field;

            delete $fd_field->{field_type};
            $fd_field->{field_class} = 'Select';

            $fd_field->{options_delegate} = FSConnector(
                $self,
                'get_options_from_db',
                \%field_params
            );
        }
        else {
            $fd_field->{$_} = $field_params{$_} for (keys %field_params);
        }
    }

    $self->form_sensible_flattened( $form_definition );

    # it's cool to be recursive sometimes :)
    return $self->build_form_sensible_object;
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

    for (keys %$values) {
        if ($values->{$_} eq '') {
            delete $values->{$_};
        }
    }

    my $submit_form_action = "submit_form_$action";

    return $self->$submit_form_action($row, $values);
}

sub submit_form_create {
    my ( $self, $row, $values ) = @_;

    $row->set_columns( $values );
    $row->insert;

    return 1;
}

sub submit_form_update {
    my ( $self, $row, $values ) = @_;

    $row->update( $values );

    return 1;
}

sub get_options_from_db {
    my ($self, $field, $args) = @_;

    my $label    = $args->{label}    || $args->{value};
    my $value    = $args->{value}    || $args->{label};

    (my $label_as = $label) =~ s[\.][_]g; # being friendly with older perls

    my $order_by = $args->{order_by} || $label;

    my $columns  = $args->{columns};

    if (!$columns) {
        # using hash to avoid duplicate columns
        # if it's a foreign key (e.g. person.name)
        # I only want the column (person)
        my %columns = map {
            m[(.*)\.] ? ( $1 => 1 ) : ( $_ => 1 )
        } ($label, $value);

        $columns = [ keys %columns ];
    }

    my %options = (
        columns   => $columns,
        order_by  => $order_by,
    );

    if ($label =~ m[(.*)\.]) {
        @options{'+select', '+as', 'join'} = (
            [ $label        ],
            [ $label_as     ],
            [ $1            ],
        );
    }
    my $search = $self->crud_model_instance->result_source->related_source(
        $args->{related_source}
    )->resultset->search($args->{filter}, \%options);

    my @options = ($field->required)
                ? ()
                : ({ name => 'Selecione' })
                ;
    push @options,
        map {
            {
                name  => $_->get_column($label_as),
                value => $_->get_column($value),
            }
        } $search->all;

    return \@options;
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
