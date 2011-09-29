package Impacto::Form::Product::Product;
use HTML::FormHandler::Moose;
extends 'HTML::FormHandler::Model::DBIC';
with 'HTML::FormHandler::Render::Simple';

use namespace::autoclean;

has '+item_class' => ( default => 'Product' );

has_field 'custom_fields' => ( type => 'TextArea', );
has_field 'image' => ( type => 'Text', );
has_field 'weight' => ( type => 'Text', );
has_field 'price' => ( type => 'Text', required => 1, );
has_field 'minimum_price' => ( type => 'Text', );
has_field 'cost' => ( type => 'Text', required => 1, );
has_field 'supplier' => ( type => 'TextArea', );
has_field 'name' => ( type => 'TextArea', required => 1, );
has_field 'product_categories' => ( type => '+ProductCategoryField', );
has_field 'product_stocks' => ( type => '+ProductStockField', );
has_field 'stock_movements' => ( type => '+StockMovementField', );
has_field 'subscriptions' => ( type => '+SubscriptionField', );
has_field 'submit' => ( type => 'Submit' );

1;
