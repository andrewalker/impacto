package Impacto::Form::People::Address;
use HTML::FormHandler::Moose;
extends 'HTML::FormHandler::Model::DBIC';
with 'HTML::FormHandler::Render::Simple';

use namespace::autoclean;

has '+item_class' => ( default => 'Address' );

has_field 'phone' => ( type => 'TextArea', );
has_field 'country' => ( type => 'TextArea', required => 1, );
has_field 'state' => ( type => 'TextArea', required => 1, );
has_field 'city' => ( type => 'TextArea', required => 1, );
has_field 'zip_code' => ( type => 'TextArea', required => 1, );
has_field 'street' => ( type => 'TextArea', required => 1, );
has_field 'number' => ( type => 'Integer', required => 1, );
has_field 'is_main_address' => ( type => 'Text', required => 1, );
has_field 'name' => ( type => 'TextArea', required => 1, );
has_field 'person' => ( type => 'Select', );
has_field 'submit' => ( type => 'Submit' );

1;
