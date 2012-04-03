package Form::SensibleX::FieldFactory::RecordMeta;

use Moose;
use namespace::autoclean;
use Form::Sensible::DelegateConnection;

extends 'Form::Sensible::Field::Text';

# form extra params:
# meta_fields => { x_field_factory => 'RecordMeta', custom_field_name => 'name', custom_field_value => 'value', table => 'product_meta' }
# crazy.

__PACKAGE__->meta->make_immutable;

1;
