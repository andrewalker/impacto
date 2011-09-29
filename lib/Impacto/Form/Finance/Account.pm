package Impacto::Form::Finance::Account;
use HTML::FormHandler::Moose;
extends 'HTML::FormHandler::Model::DBIC';
with 'HTML::FormHandler::Render::Simple';

use DateTime;

use namespace::autoclean;

has '+item_class' => ( default => 'Account' );

has_field 'balance' => ( type => 'Text', required => 1, );
has_field 'agency' => ( type => 'TextArea', );
has_field 'account_number' => ( type => 'TextArea', );
has_field 'bank' => ( type => 'TextArea', );
has_field 'installment_payments' => ( type => '+InstallmentPaymentField', );
has_field 'ledgers' => ( type => '+LedgerField', );
has_field 'submit' => ( type => 'Submit' );

1;
