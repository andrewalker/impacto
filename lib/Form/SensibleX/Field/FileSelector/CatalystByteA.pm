package Form::SensibleX::Field::FileSelector::CatalystByteA;

use Moose;
use namespace::autoclean;

extends 'Form::SensibleX::Field::FileSelector::Catalyst';
with 'Form::SensibleX::FieldRole::FileSelector::ByteA';

__PACKAGE__->meta->make_immutable;

1;
