package Impacto::Form::Sensible::Reflector::DBIC;
use Moose;
use namespace::autoclean;

extends 'Form::Sensible::Reflector::DBIC';

sub BUILD {
    my $self = shift;

    $self->field_type_map->{text}->{defaults}->{field_class} = 'Text';
    $self->field_type_map->{boolean} = {
        defaults => { field_class => 'Toggle' },
    };
}

1;
