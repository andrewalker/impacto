package Impacto::Form::Product::Place;
use HTML::FormHandler::Moose;
extends 'HTML::FormHandler::Model::DBIC';
with 'HTML::FormHandler::Render::Simple';

use namespace::autoclean;

has '+item_class' => ( default => 'Place' );

has_field 'product_stocks' => ( type => '+ProductStockField', );
has_field 'stock_movements' => ( type => '+StockMovementField', );
has_field 'submit' => ( type => 'Submit' );

1;
