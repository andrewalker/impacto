package Impacto::Form::People::Employee;
use HTML::FormHandler::Moose;
extends 'HTML::FormHandler::Model::DBIC';
with 'HTML::FormHandler::Render::Simple';

use namespace::autoclean;

has '+item_class' => ( default => 'Employee' );

has_field 'person' => ( type => 'Select', );
has_field 'submit' => ( type => 'Submit' );

1;
