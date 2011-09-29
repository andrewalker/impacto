package Impacto::Form::Finance::Ledger;
use HTML::FormHandler::Moose;
extends 'HTML::FormHandler::Model::DBIC';
with 'HTML::FormHandler::Render::Simple';

use namespace::autoclean;

has '+item_class' => ( default => 'Ledger' );

has_field 'comment' => ( type => 'TextArea', );
has_field 'stock_movement' => ( type => 'Integer', );
has_field 'datetime' => ( type => 'Text', required => 1, );
has_field 'value' => ( type => 'Text', required => 1, );
has_field 'account' => ( type => 'Select', );
has_field 'ledger_type' => ( type => 'Select', );
has_field 'installments' => ( type => '+InstallmentField', );
has_field 'submit' => ( type => 'Submit' );

1;
