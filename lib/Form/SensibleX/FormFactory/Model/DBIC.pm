package Form::SensibleX::FormFactory::Model::DBIC;
use Moose;
use Bread::Board;

# FIXME: get this as a parameter
use Impacto::Form::Sensible::Reflector::DBIC;

# make sure all FS symbols are loaded
# even though we don't need it directly
use Form::Sensible;

use Hash::Merge qw(merge);
use namespace::autoclean;

extends 'Bread::Board::Container';

has '+name' => ( default => 'Model' );

has resultset => (
    isa => 'DBIx::Class::ResultSet',
    is  => 'ro',
);

has row => (
#    isa     => 'DBIx::Class::Row|Undef',
    is      => 'ro',
    lazy    => 1,
    default => sub { shift->resultset->new_result({}) },
);

sub BUILD {
    my $self = shift;

    container $self => as {
        service resultset     => $self->resultset;
        service row           => $self->row;
        service result_source => (
            block => sub {
                my $self = shift;
                $self->param('resultset')->result_source;
            },
            dependencies => [ depends_on('resultset') ],
            lifecycle => 'Singleton',
        );

        service related_resultset => (
            dependencies => [ depends_on('result_source') ],
            parameters   => { field => { is => 'ro', isa => 'Str' } },
            block => sub {
                my $self = shift;
                return $self->param('result_source')->related_source( $self->param('field') )->resultset;
            },
        );

        service reflect => (
            dependencies => {
                columns       => depends_on('/column_order'),
                result_source => depends_on('result_source'),
                resultset     => depends_on('resultset'),
            },
            block => sub {
                my $self      = shift;
                my $columns   = $self->param('columns');
                my $source    = $self->param('result_source');
                my $reflector = Impacto::Form::Sensible::Reflector::DBIC->new();
                my %db_columns = map { $_ => 1 } $source->columns;
                my @db_columns = grep { $db_columns{$_} } @$columns;

                my $form_options = {
                    form             => { name => $source->from },
                    with_trigger     => 1,
                    fieldname_filter => sub { @db_columns },
                };

                return $reflector->reflect_from( $self->param('resultset'), $form_options );
            },
        );

        service flattened_reflection => (
            dependencies => [ depends_on('reflect') ],
            block        => sub { shift->param('reflect')->flatten },
            lifecycle    => 'Singleton',
        );

        service set_values_from_row => (
            dependencies => [ depends_on('/form'), depends_on('get_db_values_from_row') ],
            block        => sub {
                my $self = shift;
                $self->param('form')->set_values( $self->param('get_db_values_from_row') );
            },
        );

        service prepare_get_db_values_from_row => (
            dependencies => [ depends_on('/form'), depends_on('row') ],
            block        => sub {
                my $self = shift;
                my $form = $self->param('form');
                my $row  = $self->param('row');

                my $values    = {};
                my $factories = {};

                for my $fieldname ( $form->fieldnames ) {
                    my $field   = $form->field($fieldname);
                    my $factory = $field->{from_factory};

                    next if $field->field_type eq 'trigger';

                    if (defined $factory) {
                        $factories->{$factory} ||= [];
                        push @{ $factories->{$factory} }, $fieldname;
                    }
                    else {
                        $values->{$fieldname} = $row->get_column($fieldname);
                    }
                }

                return ( $values, $factories );
            },
        );

        service get_db_values_from_row => (
            dependencies => [
                vf   => depends_on('prepare_get_db_values_from_row'),
                # FIXME: really dumb!
                root => depends_on('/form_factory'),
                row  => depends_on('row'),
            ],
            block => sub {
                my $self = shift;
                my ($values, $factories) = $self->param('vf');

                my @values;

                for my $factory (keys %$factories) {
                    my $ff = $self->param('root')->get_field_factory($factory);
                    push @values, %{
                        $ff->get_values_from_row( $self->param('row'), $factories->{$factory} )
                    };
                }

                return merge( $values, { @values } );
            }
        );

        service get_db_values_and_factories_from_form => (
            lifecycle => 'Singleton',
            dependencies => [ depends_on('/form') ],
            block => sub {
                my $self = shift;
                my $form = $self->param('form');

                my $values    = {};
                my $factories = {};

                for my $fieldname ( $form->fieldnames ) {
                    my $field   = $form->field($fieldname);
                    my $value   = $field->value();
                    my $factory = $field->{from_factory};

                    next if defined $value && $value eq '';
                    next if $field->field_type eq 'trigger';

                    if (defined $factory) {
                        $factories->{$factory} ||= {};
                        $factories->{$factory}{$fieldname} = $value;
                    }
                    else {
                        $values->{$fieldname} = $value;
                    }
                }

                return ($values, $factories);
            }
        );

        service validate_form => (
            dependencies => [ depends_on('/form') ],
            block        => sub { shift->param('form')->validate()->is_valid },
            lifecycle    => 'Singleton', # as long as this doesn't persist through requests
        );

        service execute_create => (
            dependencies => [ depends_on('row'), depends_on('pre_execute'), depends_on('get_db_values_and_factories_from_form') ],
            block        => sub {
                my $self = shift;
                return 0 if !$self->param('pre_execute');
                my ($values, $field_factories) = $self->param('get_db_values_and_factories_from_form');
                my $row = $self->param('row');
                $row->set_columns( $values );
                $row->insert;
                return 1;
            },
        );

        service execute_update => (
            dependencies => [ depends_on('row'), depends_on('pre_execute'), depends_on('get_db_values_and_factories_from_form') ],
            block        => sub {
                my $self = shift;
                return 0 if !$self->param('pre_execute');
                my ($values, $field_factories) = $self->param('get_db_values_and_factories_from_form');
                my $row = $self->param('row');
                $row->update( $values );
                return 1;
            },
        );

        service pre_execute => (
            dependencies => {
                root     => depends_on('/form_factory'),
                row      => depends_on('row'),
                validate => depends_on('validate_form'),
                vf       => depends_on('get_db_values_and_factories_from_form'),
            },
            block        => sub {
                my $self = shift;
                return 0 if !$self->param('validate');
                my ($values, $field_factories) = $self->param('vf');
                my $row = $self->param('row');
                my $root = $self->param('/form_factory');

                my $result = 1;

                for my $field_factory_class (keys %$field_factories) {
                    return 0 if !$result;
                    my $obj = $root->get_field_factory($field_factory_class);
                    $result = $obj->prepare_execute($row, $field_factories->{$field_factory_class});
                }

                return $result;
            },
        );

        service post_execute => (
            dependencies => {
                # FIXME: really dumb!
                root => depends_on('/form_factory'),
                row  => depends_on('row'),
                vf   => depends_on('get_db_values_and_factories_from_form'),
            },
            block        => sub {
                my $self = shift;
                my ($values, $field_factories) = $self->param('vf');
                my $row = $self->param('row');
                my $root = $self->param('root');

                my $result = 1;

                for my $field_factory_class (keys %$field_factories) {
                    return 0 if !$result;

                    # this probably means it should be in the root container
                    my $obj = $root->get_field_factory($field_factory_class);

                    $result = $obj->execute($row, $field_factories->{$field_factory_class});
                }

                return $result;
            },
        );
    };
}

sub execute {
    my ($self, $action) = @_;

    return $self->resolve(service => "execute_$action") &&
           $self->resolve(service => "post_execute");
}

__PACKAGE__->meta->make_immutable;

1;

__END__

=head1 NAME

Form::SensibleX::FormFactory::Model::DBIC - Save form data in DBIC

=head1 DESCRIPTION

Handles all the communication with the database, like filling the form, updating the row, or creating a new row.

=head1 METHODS

=head2 BUILD

Builds the Bread::Board container.

=head2 execute

Saves the record in the database. Either updates an existing row, or creates a new one.

=head1 AUTHOR

André Walker <andre@andrewalker.net>

=head1 LICENSE

This library is free software. You can redistribute it and/or modify
it under the same terms as Perl itself.
