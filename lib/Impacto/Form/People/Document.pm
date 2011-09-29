package Impacto::Form::People::Document;
use HTML::FormHandler::Moose;
extends 'HTML::FormHandler::Model::DBIC';
with 'HTML::FormHandler::Render::Simple';

use namespace::autoclean;

has '+item_class' => ( default => 'Document' );

has_field 'value' => ( type => 'TextArea', );
has_field 'type' => ( type => 'TextArea', required => 1, );
has_field 'person' => ( type => 'Select', );
has_field 'submit' => ( type => 'Submit' );

1;
