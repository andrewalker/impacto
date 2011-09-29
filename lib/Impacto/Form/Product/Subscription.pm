package Impacto::Form::Product::Subscription;
use HTML::FormHandler::Moose;
extends 'HTML::FormHandler::Model::DBIC';
with 'HTML::FormHandler::Render::Simple';

use namespace::autoclean;

has '+item_class' => ( default => 'Subscription' );

has_field 'expiry_edition' => ( type => 'Integer', );
has_field 'expiry_date' => ( type => 'Text', );
has_field 'subscription_edition' => ( type => 'Integer', );
has_field 'subscription_date' => ( type => 'Text', required => 1, );
has_field 'active' => ( type => 'Text', required => 1, );
has_field 'client' => ( type => 'TextArea', required => 1, );
has_field 'product' => ( type => 'Select', );
has_field 'submit' => ( type => 'Submit' );

1;
