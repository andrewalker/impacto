package Impacto::Form::People::Person;
use HTML::FormHandler::Moose;
extends 'HTML::FormHandler::Model::DBIC';
with 'HTML::FormHandler::Render::Simple';

use namespace::autoclean;

has '+item_class' => ( default => 'Person' );

has_field 'comments' => ( type => 'TextArea', );
has_field 'site' => ( type => 'TextArea', );
has_field 'email' => ( type => 'TextArea', );
has_field 'phone' => ( type => 'TextArea', );
has_field 'name' => ( type => 'TextArea', required => 1, );
has_field 'representant' => ( type => 'Select', );
has_field 'client' => ( type => 'Select', );
has_field 'addresses' => ( type => '+AddressField', );
has_field 'documents' => ( type => '+DocumentField', );
has_field 'employee' => ( type => 'Select', );
has_field 'supplier' => ( type => 'Select', );
has_field 'bank_accounts' => ( type => '+BankAccountField', );
has_field 'submit' => ( type => 'Submit' );

1;
