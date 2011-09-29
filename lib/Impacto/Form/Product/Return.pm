package Impacto::Form::Product::Return;
use HTML::FormHandler::Moose;
extends 'HTML::FormHandler::Model::DBIC';
with 'HTML::FormHandler::Render::Simple';

use namespace::autoclean;

has '+item_class' => ( default => 'Return' );

has_field 'ledger' => ( type => 'Integer', );
has_field 'amount' => ( type => 'Integer', required => 1, );
has_field 'datetime' => ( type => 'Text', required => 1, );
has_field 'consignation' => ( type => 'Select', );
has_field 'stock_movement' => ( type => 'Select', );
has_field 'submit' => ( type => 'Submit' );

1;
