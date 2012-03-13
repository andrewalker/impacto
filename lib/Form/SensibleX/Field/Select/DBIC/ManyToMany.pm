package Form::SensibleX::Field::Select::DBIC::ManyToMany;

use Moose;
use namespace::autoclean;
use Form::Sensible::DelegateConnection;

extends 'Form::Sensible::Field::Select';

# form extra params:
# categories => { many_to_many => 1, option_label => 'name', option_value => 'id' }

__PACKAGE__->meta->make_immutable;

1;
