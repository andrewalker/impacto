package Impacto::Form::Finance::LedgerType;
use HTML::FormHandler::Moose;
extends 'HTML::FormHandler::Model::DBIC';
with 'HTML::FormHandler::Render::Simple';

use namespace::autoclean;

has '+item_class' => ( default => 'LedgerType' );

has_field 'name' => ( type => 'TextArea', required => 1, );
has_field 'ledgers' => ( type => '+LedgerField', );
has_field 'submit' => ( type => 'Submit' );

1;
