package Impacto::Form::Finance::InstallmentPayment;
use HTML::FormHandler::Moose;
extends 'HTML::FormHandler::Model::DBIC';
with 'HTML::FormHandler::Render::Simple';

use DateTime;

use namespace::autoclean;

has '+item_class' => ( default => 'InstallmentPayment' );

has_field 'comments' => ( type => 'TextArea', );
has_field 'payment_method' => ( type => 'TextArea', );
has_field 'amount' => ( type => 'Text', required => 1, );
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
has_field 'account' => ( type => 'Select', );
has_field 'installment' => ( type => 'Select', );
has_field 'submit' => ( type => 'Submit' );

1;
