package Impacto::DBIC::Result;

use Moose;
use MooseX::NonMoose;
use namespace::autoclean;
extends 'DBIx::Class::Core';



__PACKAGE__->meta->make_immutable;

1;
