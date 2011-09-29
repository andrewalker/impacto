package Impacto::Form::Product::Category;
use HTML::FormHandler::Moose;
extends 'HTML::FormHandler::Model::DBIC';
with 'HTML::FormHandler::Render::Simple';

use namespace::autoclean;

has '+item_class' => ( default => 'Category' );

has_field 'name' => ( type => 'TextArea', required => 1, );
has_field 'parent' => ( type => 'TextArea', );
has_field 'product_categories' => ( type => '+ProductCategoryField', );
has_field 'submit' => ( type => 'Submit' );

1;
