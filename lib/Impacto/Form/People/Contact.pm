package Impacto::Form::People::Contact;
use HTML::FormHandler::Moose;
extends 'HTML::FormHandler::Model::DBIC';
with 'HTML::FormHandler::Render::Simple';

use DateTime;

use namespace::autoclean;

has '+item_class' => ( default => 'Contact' );

has_field 'abstract' => ( type => 'TextArea', required => 1, );
has_field 'type' => ( type => 'TextArea', required => 1, );
has_field 'answered' => ( type => 'Text', required => 1, );
has_field 'date' => ( 
            type => 'Compound',
            apply => [
                {
                    transform => sub{ DateTime->new( $_[0] ) },
                    message => "Not a valid DateTime",
                }
            ],
        );
        has_field 'date.year';        has_field 'date.month';        has_field 'date.day';
has_field 'client' => ( type => 'Select', );
has_field 'submit' => ( type => 'Submit' );

1;
