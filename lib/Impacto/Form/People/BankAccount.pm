package Impacto::Form::People::BankAccount;
use HTML::FormHandler::Moose;
extends 'HTML::FormHandler::Model::DBIC';
with 'HTML::FormHandler::Render::Simple';

use namespace::autoclean;

has '+item_class' => ( default => 'BankAccount' );

has_field 'comments' => ( type => 'TextArea', );
has_field 'is_savings_account' => ( type => 'Text', required => 1, );
has_field 'agency' => ( type => 'TextArea', );
has_field 'account' => ( type => 'TextArea', required => 1, );
has_field 'bank' => ( type => 'TextArea', required => 1, );
has_field 'person' => ( type => 'Select', );
has_field 'submit' => ( type => 'Submit' );

1;
