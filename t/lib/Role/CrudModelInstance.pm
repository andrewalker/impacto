package Role::CrudModelInstance;
use Moose::Role;
use Schema;
use FindBin '$Bin';

requires 'crud_model_name';

has crud_model_instance => (
    is => 'ro',
    isa => 'DBIx::Class::ResultSet',
    lazy_build => 1,
);

sub _build_crud_model_instance {
    my $self = shift;

    return Schema->connect("dbi:SQLite:$Bin/db/test.db")->resultset(
        $self->crud_model_name
    );
}

sub get_all_columns { [ shift->crud_model_instance->result_source->columns ] }

no Moose::Role;
1;
