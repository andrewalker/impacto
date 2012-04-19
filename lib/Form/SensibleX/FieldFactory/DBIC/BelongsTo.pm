package Form::SensibleX::FieldFactory::DBIC::BelongsTo;

use Moose;
use namespace::autoclean;
use Form::Sensible::DelegateConnection;
use Form::SensibleX::Field::DBIC::BelongsTo;

has model => ( is => 'ro' );

has fields => (
    is      => 'ro',
    isa     => 'ArrayRef[Form::SensibleX::Field::DBIC::BelongsTo]',
    default => sub { [] },
    traits  => ['Array'],
    handles => {
        push_field => 'push',
        field_count => 'count',
    }
);

around BUILDARGS => sub {
    my $orig  = shift;
    my $class = shift;

    my %field_args = ref $_[0] && ref $_[0] eq 'HASH' ? %{$_[0]} : @_;
    my %args;

    $field_args{resultset} = $field_args{model}->related_resultset( $field_args{name} );
    $args{model} = $field_args{model};
    delete $field_args{model};
    delete $field_args{request};

    $args{fields} = [ Form::SensibleX::Field::DBIC::BelongsTo->new(%field_args) ];
    $args{fields}->[0]->{from_factory} = __PACKAGE__;

    return $class->$orig(%args);
};

sub add_field {
    my ( $self, $args ) = @_;

    $args->{resultset} = $self->model->related_resultset( $args->{name} );
    my $field = Form::SensibleX::Field::DBIC::BelongsTo->new($args);
    $field->{from_factory} = __PACKAGE__;
    $self->push_field($field);

    return 1;
}

sub execute { 1 }

sub prepare_execute {
    my ( $self, $row, $fields ) = @_;
    my $i = 0;

    foreach my $keys (values %$fields) {
        my $value   = $self->fields->[$i]->value;
        if (ref $value) {
            for my $k (keys %$value) {
                $row->set_column($k => $value->{$k});
            }
        }
        else {
            $row->set_column($self->fields->[$i]->name => $value);
        }
        $i++;
    }

    return $i > 0;
}

sub get_values_from_row {
    my ( $self, $row, $fields ) = @_;

# FIXME:
# i'm ignoring $fields

    return {
        map { $self->fields->[$_]->name => $self->fields->[$_]->get_values_from_row($row) } 0..($self->field_count-1)
    };
}

sub build_fields {
    my $self = shift;

    return map { [ $self->fields->[$_], $self->fields->[$_]->name ] } 0..($self->field_count-1);
}

__PACKAGE__->meta->make_immutable;

1;
