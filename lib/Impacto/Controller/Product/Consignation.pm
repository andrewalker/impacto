package Impacto::Controller::Product::Consignation;
use Moose;
use namespace::autoclean;

BEGIN { extends 'Impacto::ControllerBase::CRUD' }

has '+crud_model_name' => ( default => 'DB::Product::Consignation' );
sub _build_form_columns_extra_params {
    {
        representant => { fk => 1, label => 'person.name', value => 'person' },
        stock_movement => { fk => 1, value => 'id' },
        product => { fk => 1, label => 'name', value => 'id' },
    }
}

=head1 NAME

Impacto::Controller::Product::Consignation - Catalyst Controller

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
