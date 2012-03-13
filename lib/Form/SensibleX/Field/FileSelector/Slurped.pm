package Form::SensibleX::Field::FileSelector::Slurped;

use Moose;
use namespace::autoclean;
use Form::Sensible::DelegateConnection;

extends 'Form::Sensible::Field::FileSelector';

__PACKAGE__->meta->make_immutable;

1;
