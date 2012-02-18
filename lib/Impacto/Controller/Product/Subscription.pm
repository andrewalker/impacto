package Impacto::Controller::Product::Subscription;
use Moose;
use namespace::autoclean;

BEGIN { extends 'Impacto::ControllerBase::CRUD' }

has '+crud_model_name' => ( default => 'DB::ProductSubscription' );
sub _build_form_columns_extra_params {
    {
        client => { fk => 1, label => 'person.name', value => 'person' },
        product => { fk => 1, label => 'name', value => 'id' },
    }
}

=head1 NAME

Impacto::Controller::Product::Subscription - Catalyst Controller

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
