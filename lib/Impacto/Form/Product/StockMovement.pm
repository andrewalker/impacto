package Impacto::Form::Product::StockMovement;
use HTML::FormHandler::Moose;
extends 'HTML::FormHandler::Model::DBIC';
with 'HTML::FormHandler::Render::Simple';

use DateTime;

use namespace::autoclean;

has '+item_class' => ( default => 'StockMovement' );

has_field 'type' => ( type => 'Text', required => 1, );
has_field 'amount' => ( type => 'Integer', required => 1, );
has_field 'datetime' => ( type => 'Text', required => 1, );
has_field 'returns' => ( type => '+ReturnField', );
has_field 'place' => ( type => 'Select', );
has_field 'consignations' => ( type => '+ConsignationField', );
has_field 'product' => ( type => 'Select', );
has_field 'submit' => ( type => 'Submit' );

1;
