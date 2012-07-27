package Impacto::Controller::Product::Consignation;
use Moose;
use namespace::autoclean;

BEGIN { extends 'Impacto::ControllerBase::CRUD' }

has '+crud_model_name' => ( default => 'DB::ProductConsignation' );

sub datagrid_columns {
    [qw/datetime product amount representant expected_return/];
}

sub datagrid_columns_extra_params {
    {
        product      => { fk => 'product.name' },
        representant => { fk => 'person.name' },
    }
}

sub form_columns_extra_params {
    {
        representant => { x_field_factory => "DBIC::BelongsTo", option_label => 'person.name', option_value => 'person' },
        stock_movement => { x_field_factory => "DBIC::BelongsTo", option_value => 'id' },
        product => { x_field_factory => "DBIC::BelongsTo", option_label => 'name', option_value => 'id' },
    }
}

__PACKAGE__->meta->make_immutable;

1;

__END__

=encoding utf8

=head1 NAME

Impacto::Controller::Product::Consignation - Catalyst Controller

=head1 DESCRIPTION

Catalyst Controller.

=head1 METHODS

=head1 AUTHOR

André Walker

=head1 LICENSE

This library is free software. You can redistribute it and/or modify
it under the same terms as Perl itself.
