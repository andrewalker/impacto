package Impacto::Form::Product::Consignation;
use HTML::FormHandler::Moose;
extends 'HTML::FormHandler::Model::DBIC';
with 'HTML::FormHandler::Render::Simple';

use DateTime;

use namespace::autoclean;

has '+item_class' => ( default => 'Consignation' );

has_field 'representant' => ( type => 'TextArea', required => 1, );
has_field 'amount' => ( type => 'Integer', required => 1, );
has_field 'product' => ( type => 'Integer', required => 1, );
has_field 'expected_return' => ( 
            type => 'Compound',
            apply => [
                {
                    transform => sub{ DateTime->new( $_[0] ) },
                    message => "Not a valid DateTime",
                }
            ],
        );
        has_field 'expected_return.year';        has_field 'expected_return.month';        has_field 'expected_return.day';
has_field 'datetime' => ( type => 'Text', required => 1, );
has_field 'returns' => ( type => '+ReturnField', );
has_field 'stock_movement' => ( type => 'Select', );
has_field 'submit' => ( type => 'Submit' );

1;
