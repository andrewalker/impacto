package Impacto::Controller::People::BankAccount;
use Moose;
use namespace::autoclean;

BEGIN { extends 'Impacto::ControllerBase::CRUD' }

has '+crud_model_name' => ( default => 'DB::People::BankAccount' );
sub _build_form_columns_extra_params {
    {
        person => { fk => 1, label => 'name', value => 'slug', },
        comments => { field_class => 'LongText' },
    }
}

=head1 NAME

Impacto::Controller::People::BankAccount - Catalyst Controller

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
