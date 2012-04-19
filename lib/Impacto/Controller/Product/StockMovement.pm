package Impacto::Controller::Product::StockMovement;
use utf8;
use Moose;
use namespace::autoclean;
use Form::Sensible::DelegateConnection;

BEGIN { extends 'Impacto::ControllerBase::CRUD' }

has '+crud_model_name' => ( default => 'DB::ProductStockMovement' );
sub datagrid_columns {
    [ qw/ datetime amount type place product / ]
}
sub datagrid_columns_extra_params {
    {
        product => { fk => 'product.name' }
    }
}
sub form_columns {
    [ qw/ datetime amount type place product / ]
}
sub form_columns_extra_params {
    my $self = shift;
    {
        type => { field_class => 'Select', options_delegate => FSConnector($self, 'get_stock_movement_types') },
        place => { x_field_factory => "DBIC::BelongsTo", option_label => 'place' },
        product => { x_field_factory => "DBIC::BelongsTo", option_label => 'name', option_value => 'id' },
    }
}

sub get_stock_movement_types {
    my ($self, $field, $args) = @_;
    return [
        { value => 'sell',         name => 'Venda' },
        { value => 'buy',          name => 'Compra' },
        { value => 'consignation', name => 'Consignação' },
        { value => 'return',       name => 'Retorno' },
        { value => 'donation',     name => 'Doação' },
        { value => 'relocation',   name => 'Mudança de local' },
    ];
}

=head1 NAME

Impacto::Controller::Product::StockMovement - Catalyst Controller

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
