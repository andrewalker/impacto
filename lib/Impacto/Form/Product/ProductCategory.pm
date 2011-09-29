package Impacto::Form::Product::ProductCategory;
use HTML::FormHandler::Moose;
extends 'HTML::FormHandler::Model::DBIC';
with 'HTML::FormHandler::Render::Simple';

use namespace::autoclean;

has '+item_class' => ( default => 'ProductCategory' );

has_field 'slug' => ( type => 'Select', );
has_field 'id' => ( type => 'Select', );
has_field 'submit' => ( type => 'Submit' );

1;
