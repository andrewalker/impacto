package Form::SensibleX::FormFactory::Container;
use Bread::Board;
use Moose;
use namespace::autoclean;

extends 'Bread::Board::Container::Parameterized';

has '+allowed_parameter_names' => ( default => sub { [ qw/Model Request/ ] } );

sub BUILD {
    my $self = shift;

    $self->add_service(
        $self->${\"build_${_}_service"}
    ) for qw/
        form_definition
        form
        add_factories
        add_to_form
        replace_fields
        execute
        extra_columns
        column_order
    /;
}

sub build_form_definition_service {
    my $self = shift;

    return Bread::Board::BlockInjection->new(
        lifecycle    => 'Singleton',
        name         => 'form_definition',
#        dependencies => [ depends_on() ],
        block        => sub {
        }
    );
}

sub build_add_to_form_service {
    my $self = shift;

    return Bread::Board::BlockInjection->new(
        lifecycle    => 'Singleton',
        name         => 'add_to_form',
#        dependencies => [ depends_on() ],
        block        => sub {
        }
    );
}

sub build_add_factories_service {
    my $self = shift;

    return Bread::Board::BlockInjection->new(
        lifecycle    => 'Singleton',
        name         => 'add_factories',
#        dependencies => [ depends_on() ],
        block        => sub {
        }
    );
}

sub build_form_service {
    my $self = shift;

    return Bread::Board::BlockInjection->new(
        name         => 'form',
#        dependencies => [ depends_on() ],
        block        => sub {
        }
    );
}

sub build_replace_fields_service {
    my $self = shift;

    return Bread::Board::BlockInjection->new(
        name         => 'replace_fields',
#        dependencies => [ depends_on() ],
        block        => sub {
        }
    );
}

sub build_execute_service {
    my $self = shift;

    return Bread::Board::BlockInjection->new(
        name         => 'execute',
#        dependencies => [ depends_on() ],
        block        => sub {
        }
    );
}

sub build_extra_columns_service {
    my $self = shift;

    return Bread::Board::BlockInjection->new(
        name         => 'extra_columns',
#        dependencies => [ depends_on() ],
        block        => sub {
        }
    );
}

sub build_column_order_service {
    my $self = shift;

    return Bread::Board::BlockInjection->new(
        name         => 'column_order',
#        dependencies => [ depends_on() ],
        block        => sub {
        }
    );
}

__PACKAGE__->meta->make_immutable;

1;
