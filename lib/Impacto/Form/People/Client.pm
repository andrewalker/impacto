package Impacto::Form::People::Client;
use HTML::FormHandler::Moose;
extends 'HTML::FormHandler::Model::DBIC';
with 'HTML::FormHandler::Render::Simple';

use namespace::autoclean;

has '+item_class' => ( default => 'Client' );

has_field 'person' => ( type => 'Select', );
has_field 'contact' => ( type => 'Select', );
has_field 'submit' => ( type => 'Submit' );

1;
