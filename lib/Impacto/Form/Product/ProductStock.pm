package Impacto::Form::Product::ProductStock;
use HTML::FormHandler::Moose;
extends 'HTML::FormHandler::Model::DBIC';
with 'HTML::FormHandler::Render::Simple';

use namespace::autoclean;

has '+item_class' => ( default => 'ProductStock' );

has_field 'amount' => ( type => 'Integer', required => 1, );
has_field 'place' => ( type => 'Select', );
has_field 'product' => ( type => 'Select', );
has_field 'submit' => ( type => 'Submit' );

1;
