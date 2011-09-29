package Impacto::Form::UserAccount::UserAccount;
use HTML::FormHandler::Moose;
extends 'HTML::FormHandler::Model::DBIC';
with 'HTML::FormHandler::Render::Simple';

use namespace::autoclean;

has '+item_class' => ( default => 'UserAccount' );

has_field 'name' => ( type => 'TextArea', required => 1, );
has_field 'password' => ( type => 'TextArea', required => 1, );
has_field 'user_account_roles' => ( type => '+UserAccountRoleField', );
has_field 'submit' => ( type => 'Submit' );

1;
