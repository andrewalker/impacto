package Form::SensibleX::FormFactory::Model::DBIC;
use Moose;
use Bread::Board;
use Moose::Util::TypeConstraints qw/enum/;

# FIXME: get this as a parameter
use Impacto::Form::Sensible::Reflector::DBIC;

use Hash::Merge qw(merge);
use namespace::autoclean;

extends 'Bread::Board::Container';

has '+name' => ( default => 'Model' );

has resultset => (
    isa => 'DBIx::Class::ResultSet',
    is  => 'ro',
);

has row => (
    isa     => 'DBIx::Class::Row',
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
            lifecycle    => 'Singleton',
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
            block        => sub {
                my $r = shift->param('reflect')->flatten;
                delete $r->{field_order};
                return $r;
            },
            lifecycle    => 'Singleton',
        );

        service get_db_values_from_row => (
            dependencies => {
                mgr    => depends_on('/field_factory_manager'),
                row    => depends_on('row'),
            },
            block => sub {
                my $self = shift;
                my $mgr  = $self->param('mgr');
                my $row  = $self->param('row');

                my %plain_values = $row->get_columns;

                my @values;

                for my $factory ($mgr->all_factories) {
                    push @values, %{
                        $factory->get_values_from_row( $row )
                    };
                }

                return merge( { @values }, \%plain_values );
            }
        );

        service row_with_form_values => (
            dependencies => [ depends_on('row'), depends_on('result_source'), depends_on('/Request/form_values') ],
            block        => sub {
                my $s = shift;
                my $form    = $s->param('form_values');
                my $row     = $s->param('row');
                my @columns = $s->param('result_source')->columns;

                foreach my $column (@columns) {
                    if ($form->{$column}) {
                        $row->set_column(
                            $column => $form->{$column}
                        );
                    }
                }

                return $row;
            }
        );

        service complete_row => (
            lifecycle    => 'Singleton',
            dependencies => {
                mgr => depends_on('/field_factory_manager'),
                row => depends_on('row_with_form_values'),
            },
            block        => sub {
                my $self = shift;
                my $row  = $self->param('row');
                my $mgr  = $self->param('mgr');

                my $result = 1;

                for my $ff ($mgr->all_factories) {
                    return 0 if !$result;
                    $result = $ff->prepare_execute($row);
                }

                return $result ? $row : 0;
            },
        );

        service execute => (
            dependencies => [ depends_on('complete_row') ],
            parameters   => {
                action => { is => 'ro', isa => enum([qw/ create update /]), required => 1 }
            },
            block        => sub {
                my $self = shift;
                my $action = $self->param('action') eq 'create' ? 'insert' : 'update';

                my $row = $self->param('complete_row');

                if (!$row) {
                    die 'no row!';
                }

                $row->$action;

                return 1;
            },
        );

        service post_execute => (
            dependencies => {
                mgr => depends_on('/field_factory_manager'),
                row => depends_on('complete_row'),
            },
            block        => sub {
                my $self = shift;
                my $row = $self->param('row');
                my $mgr = $self->param('mgr');

                my $result = 1;

                for my $ff ($mgr->all_factories) {
                    return 0 if !$result;
                    $result = $ff->execute($row);
                }

                return $result;
            },
        );
    };
}

sub execute {
    my ($self, $action) = @_;

    return $self->resolve(service => "execute", parameters => { action => $action }) &&
           $self->resolve(service => "post_execute");
}

__PACKAGE__->meta->make_immutable;

1;

__END__

=encoding utf8

=head1 NAME

Form::SensibleX::FormFactory::Model::DBIC - Save form data in DBIC

=head1 DESCRIPTION

Handles all the communication with the database, like filling the form, updating the row, or creating a new row.

=head1 METHODS

=head2 BUILD

Builds the Bread::Board container.

=head2 execute

Saves the record in the database. Either updates an existing row, or creates a
new one.

=head1 SERVICES

=head2 resultset

The resultset from DBIx::Class.

=head2 row

The row being updated, or a C<new_result({})> if it's a new row.

=head2 result_source

DBIx::Class::ResultSource object for the given resultset.

=head2 related_resultset

For a given field name, it fetches a relationship with the same name in the
result source, and returns the corresponding resultset.

=head2 reflect

Creates L<Form::Sensible::Form> object based on the schema.

=head2 flattened_reflection

Flattens the form created by L</reflect>.

=head2 prepare_get_db_values_from_row

Fetches all the values in the row to fill the form, and gets the field
factories to fetch any values besides the ones in the row.

=head2 values_from_plain_fields_from_row

Uses L</prepare_get_db_values_from_row> to get the plain values (no field
factories).

=head2 field_factories_from_row

Uses L</prepare_get_db_values_from_row> to get the field factories.

=head2 get_db_values_from_row

Uses L</field_factories_from_row> and L</values_from_plain_fields_from_row> to
merge all the values necessary for filling out the form. Returns the values.

=head2 get_db_values_and_factories_from_form

Fetches the values and field factories in the form to be inserted into the
database.

=head2 values_from_plain_fields_from_form

Uses L</get_db_values_and_factories_from_form> to get the plain values to be
inserted into the main row.

=head2 field_factories_from_form

Uses L</get_db_values_and_factories_from_form> to get the field factories to
insert the rest of the data (things L</values_from_plain_fields_from_form>
can't insert) into the database.

=head2 validate_form

Validates the form.

=head2 execute_create

Inserts a new row into the database.

=head2 execute_update

Updates an existing row in the database.

=head2 pre_execute

Prepares the execute_$action.

=head2 post_execute

Finalizes the execution, in case some of the factories need an existing row in
the database to finish their job.

=head1 AUTHOR

André Walker <andre@andrewalker.net>

=head1 LICENSE

This library is free software. You can redistribute it and/or modify
it under the same terms as Perl itself.
