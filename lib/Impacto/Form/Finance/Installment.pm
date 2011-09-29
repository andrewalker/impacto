package Impacto::Form::Finance::Installment;
use HTML::FormHandler::Moose;
extends 'HTML::FormHandler::Model::DBIC';
with 'HTML::FormHandler::Render::Simple';

use DateTime;

use namespace::autoclean;

has '+item_class' => ( default => 'Installment' );

has_field 'payed' => ( type => 'Text', required => 1, );
has_field 'amount' => ( type => 'Text', required => 1, );
has_field 'ledger' => ( type => 'Select', );
has_field 'installment_payments' => ( type => '+InstallmentPaymentField', );
has_field 'submit' => ( type => 'Submit' );

1;
