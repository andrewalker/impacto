package Impacto::Controller::Finance::Ledger;
use Moose;
use namespace::autoclean;

BEGIN { extends 'Impacto::ControllerBase::CRUD' }

has '+crud_model_name' => ( default => 'DB::FinanceLedger' );

sub form_columns_extra_params {
    {
        ledger_type    => { x_field_factory => "DBIC::BelongsTo", option_label => 'name', option_value => 'slug', },
        stock_movement => { x_field_factory => "DBIC::BelongsTo", option_label => [ 'datetime', 'product.name', 'place' ], option_value => 'id' },
        comment        => { field_class => 'LongText' },
    }
}

__PACKAGE__->meta->make_immutable;

1;

__END__

=encoding utf8

=head1 NAME

Impacto::Controller::Finance::Ledger - Catalyst Controller

=head1 DESCRIPTION

Catalyst Controller.

=head1 METHODS

=head1 AUTHOR

André Walker

=head1 LICENSE

This library is free software. You can redistribute it and/or modify
it under the same terms as Perl itself.
