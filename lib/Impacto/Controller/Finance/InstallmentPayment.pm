package Impacto::Controller::Finance::InstallmentPayment;
use Moose;
use namespace::autoclean;

BEGIN { extends 'Impacto::ControllerBase::CRUD' }

has '+crud_model_name' => ( default => 'DB::FinanceInstallmentPayment' );

sub form_columns {
    [ qw/ installment date amount account payment_method comments / ];
}

sub form_columns_extra_params {
    {
        installment => { x_field_factory => "DBIC::BelongsTo", option_label => [ qw/ledger due/ ], option_value => [ qw/ledger due/ ] },
        account    => { x_field_factory => "DBIC::BelongsTo", option_label => 'name', },
        comments   => { field_class => 'LongText' },
    }
}

__PACKAGE__->meta->make_immutable;

1;

__END__

=encoding utf8

=head1 NAME

Impacto::Controller::Finance::InstallmentPayment - Catalyst Controller

=head1 DESCRIPTION

Catalyst Controller.

=head1 METHODS

=head1 AUTHOR

André Walker

=head1 LICENSE

This library is free software. You can redistribute it and/or modify
it under the same terms as Perl itself.
