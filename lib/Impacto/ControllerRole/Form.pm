package Impacto::ControllerRole::Form;
use utf8;
use Moose::Role;
use Form::SensibleX::FormFactory;
use namespace::autoclean;

requires 'crud_model_instance';

# in the controller it would be like:
# sub form_columns {
#   return [ qw/ name date long_text_field foreign_key_field / ]
# }
# sub form_columns_extra_params {
#   return {
#       long_text_field   => { field_class => 'TextArea' },
#       foreign_key_field => { x_field_factory => "DBIC::BelongsTo", label => 'customer.company', value => 'id', order_by => 'id', filter => { name => 'filtered' } },
#   }
# }
sub form_columns { shift->get_all_columns(@_) }
sub form_columns_extra_params { +{} }

# just to be sure it exists when needed
sub get_all_columns {
    warn 'Method get_all_columns not found.';
    warn 'You should implement it in the class that uses this role.';

    return [];
}

#   sub _build_form_factory_class {
#       my $self = shift;

#       my $this_class_name = ref $self;
#       $this_class_name    =~ s,^Impacto::Controller,,;

#       my $default = 'Impacto::FormFactory';
#       my $custom  = $default . $this_class_name;

#       my $form_factory = load_first_existing_class($custom, $default);

#       return $form_factory;
#   }

# very easy to override
sub build_form_factory {
    my ( $self, $c ) = @_;

    my @row_or_nothing = ( row => $c->stash->{row} )
        if $c->stash->{row};

    my $form_files = $self->_app->path_to(qw/root forms/)->stringify;

    return Form::SensibleX::FormFactory->new(
#        controller_name => ref $self,
#        path_to_forms   => $form_files,
        columns         => $self->form_columns,
        extra_params    => $self->form_columns_extra_params,
        request_args    => { req => $c->req },
        model_args      => {
            resultset => $self->crud_model_instance,
            @row_or_nothing,
        },
    );
}

1;

__END__

=encoding utf8

=head1 NAME

Impacto::ControllerRole::Form

=head1 DESCRIPTION

Builds an HTML form to insert or update rows from the database.

=head1 METHODS

=head2 get_all_columns

Makes sure that either this method is overridden by the consumer class, or
it is just not needed (because datagrid_columns don't need it's default value).

=head2 render_form

Renders the Form::Sensible object in HTML.

=head1 AUTHOR

André Walker <andre@andrewalker.net>

=head1 LICENSE

This library is free software. You can redistribute it and/or modify
it under the same terms as Perl itself.
