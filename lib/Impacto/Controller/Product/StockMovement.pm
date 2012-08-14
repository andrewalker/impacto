package Impacto::Controller::Product::StockMovement;
use utf8;
use Moose;
use namespace::autoclean;

BEGIN { extends 'Impacto::ControllerBase::CRUD' }

my $TYPE_OPTIONS = [
    { value => 'sell',         name => 'Venda'            },
    { value => 'buy',          name => 'Compra'           },
    { value => 'consignation', name => 'Consignação'      },
    { value => 'return',       name => 'Retorno'          },
    { value => 'donation',     name => 'Doação'           },
    { value => 'relocation',   name => 'Mudança de local' },
];

has '+crud_model_name' => ( default => 'DB::ProductStockMovement' );
sub datagrid_columns {
    [ qw/ datetime product amount type place / ]
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
        type    => { field_class => 'Select', options => $TYPE_OPTIONS },
        place   => { x_field_factory => "DBIC::BelongsTo", option_label => 'place' },
        product => { x_field_factory => "DBIC::BelongsTo", option_label => 'name', option_value => 'id' },
    }
}

__PACKAGE__->meta->make_immutable;

1;

__END__

=encoding utf8

=head1 NAME

Impacto::Controller::Product::StockMovement - Catalyst Controller

=head1 DESCRIPTION

Catalyst Controller.

=head1 AUTHOR

André Walker

=head1 LICENSE

This library is free software. You can redistribute it and/or modify
it under the same terms as Perl itself.
