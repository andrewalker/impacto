package Impacto::Controller::Product::Category;
use Moose;
use namespace::autoclean;

BEGIN { extends 'Impacto::ControllerBase::CRUD' }

has '+crud_model_name' => ( default => 'DB::ProductCategory' );
sub form_columns_extra_params {
    {
        parent => { x_field_class => "ForeignKey::DBIC", option_label => 'name', option_value => 'slug' }
    }
}

=head1 NAME

Impacto::Controller::Product::Category - Catalyst Controller

=head1 DESCRIPTION

Catalyst Controller.

=head1 METHODS

=cut


=head1 AUTHOR

André Walker

=head1 LICENSE

This library is free software. You can redistribute it and/or modify
it under the same terms as Perl itself.

=cut

__PACKAGE__->meta->make_immutable;

1;
