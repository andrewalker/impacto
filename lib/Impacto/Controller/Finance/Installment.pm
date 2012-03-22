package Impacto::Controller::Finance::Installment;
use Moose;
use namespace::autoclean;

BEGIN { extends 'Impacto::ControllerBase::CRUD' }

has '+crud_model_name' => ( default => 'DB::FinanceInstallment' );
sub form_columns_extra_params {
    {
        ledger => { fk => 1, option_label => 'id', },
    }
}

=head1 NAME

Impacto::Controller::Finance::Installment - Catalyst Controller

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
