package Impacto::Controller::Finance::Ledger;
use Moose;
use namespace::autoclean;

BEGIN { extends 'Impacto::ControllerBase::CRUD' }

has '+crud_model_name' => ( default => 'DB::Finance::Ledger' );
sub _build_form_columns_extra_params {
    {
        ledger_type    => { fk => 1, label => 'name', value => 'slug', },
        stock_movement => { fk => 1, label => 'id' },
        comment        => { field_class => 'LongText' },
    }
}

=head1 NAME

Impacto::Controller::Finance::Ledger - Catalyst Controller

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
