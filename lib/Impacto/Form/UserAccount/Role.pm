package Impacto::Form::UserAccount::Role;
use HTML::FormHandler::Moose;
extends 'HTML::FormHandler::Model::DBIC';
with 'HTML::FormHandler::Render::Simple';

use namespace::autoclean;

has '+item_class' => ( default => 'Role' );

has_field 'user_account_roles' => ( type => '+UserAccountRoleField', );
has_field 'submit' => ( type => 'Submit' );

1;
