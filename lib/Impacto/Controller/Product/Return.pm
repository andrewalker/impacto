package Impacto::Controller::Product::Return;
use Moose;
use namespace::autoclean;

BEGIN { extends 'Impacto::ControllerBase::CRUD' }

has '+crud_model_name' => ( default => 'DB::ProductReturn' );

sub datagrid_columns {
    [ qw/ datetime consignation amount / ];
}

sub datagrid_columns_extra_params {
    die "TODO: see datagrid_columns_extra_params in Impacto::Controller::Product::Return";
    {
        consignation   => { fk => [ 'consignation.datetime', 'consignation.representant.name' ] },
    }
}

sub form_columns_extra_params {
    {
        consignation   => { x_field_factory => "DBIC::BelongsTo", option_value => 'id', option_label => [ 'representant', 'datetime' ] },
        stock_movement => { x_field_factory => "DBIC::BelongsTo", option_value => 'id', option_label => [ 'datetime', 'product.name' ]  },
        ledger         => { x_field_factory => "DBIC::BelongsTo", option_value => 'id' },
    }
}

__PACKAGE__->meta->make_immutable;

1;

__END__

=encoding utf8

=head1 NAME

Impacto::Controller::Product::Return - Catalyst Controller

=head1 DESCRIPTION

Catalyst Controller.

=head1 METHODS

=head1 AUTHOR

André Walker

=head1 LICENSE

This library is free software. You can redistribute it and/or modify
it under the same terms as Perl itself.
