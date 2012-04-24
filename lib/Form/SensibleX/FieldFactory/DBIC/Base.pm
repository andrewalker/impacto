package Form::SensibleX::FieldFactory::DBIC::Base;

use Moose;
use namespace::autoclean;

has names => (
    is      => 'ro',
    isa     => 'ArrayRef[Str]',
    default => sub { [] },
    traits  => ['Array'],
    handles => {
        add_name => 'push',
    }
);

has fields => (
    is      => 'ro',
    isa     => 'ArrayRef[Form::Sensible::Field]',
    default => sub { [] },
    traits  => ['Array'],
    handles => {
        _add_field  => 'push',
        field_count => 'count',
    }
);

# didn't add anything
sub add_field { 0 }

# maybe there's nothing to execute
sub execute { 1 }

# or nothing to prepare
sub prepare_execute { 1 }

sub get_values_from_row {
    my ( $self, $row, $fields ) = @_;

    my %field_table     = map  { $_ => 1                      } @$fields;
    my @filtered_fields = grep { $field_table{ $_->{_fname} } } @{ $self->fields };

    return {
        map { $_->name => $_->get_values_from_row($row) } @filtered_fields
    };
}

sub build_fields {
    my ($self, $name) = @_;

    my @filtered_fields = grep { $_->{_fname} eq $name } @{ $self->fields };

    return [ map { [ $_, $_->name ] } @filtered_fields ];
}

__PACKAGE__->meta->make_immutable;

1;
