package Impacto::Form::UserAccount::UserAccountRole;
use HTML::FormHandler::Moose;
extends 'HTML::FormHandler::Model::DBIC';
with 'HTML::FormHandler::Render::Simple';

use namespace::autoclean;

has '+item_class' => ( default => 'UserAccountRole' );

has_field 'role' => ( type => 'Select', );
has_field 'login' => ( type => 'Select', );
has_field 'submit' => ( type => 'Submit' );

1;
