use warnings;
use strict;
use FindBin '$Bin';
use lib "$Bin/lib";
use DataGrid::Default;
use Test::More;
use Test::Moose;

my $dg;
eval { $dg = DataGrid::Default->new };

ok(!$@, "constructor doesn't die");
does_ok($dg, 'Impacto::ControllerRole::DataGrid');

has_attribute_ok($dg, 'crud_model_instance');
has_attribute_ok($dg, 'i18n');
has_attribute_ok($dg, 'datagrid_columns');
has_attribute_ok($dg, 'datagrid_columns_extra_params');

my $structure = [
    {
        field => '_esid',
        name => 'ID',
    },
    {
        field    => 'id',
        name     => 'crud.product.id',
        editable => 0,
        width    => 'auto',
    },
    {
        field    => 'name',
        name     => 'crud.product.name',
        editable => 0,
        width    => 'auto',
    },
    {
        field    => 'supplier',
        name     => 'crud.product.supplier',
        editable => 0,
        width    => 'auto',
    },
    {
        field    => 'cost',
        name     => 'crud.product.cost',
        editable => 0,
        width    => 'auto',
    },
    {
        field    => 'price',
        name     => 'crud.product.price',
        editable => 0,
        width    => 'auto',
    },
];
my $datagrid_columns = [ qw/id name supplier cost price/ ];
my $extra_params     = {};

is_deeply($dg->datagrid_columns, $datagrid_columns, 'default datagrid_columns are correct');
is_deeply($dg->datagrid_columns_extra_params, $extra_params, 'default datagrid_columns_extra_params are correct');

is_deeply($dg->get_browse_structure, $structure, 'structure is correct');

my $row;
eval { $row = $dg->crud_model_instance->find(1) };

my $expected_data = {
    id       => 1,
    name     => 'Product 1',
    cost     => 25,
    price    => 50,
    supplier => 'person1',
    _pks     => { id => 1 },
};

ok(!$@, "the code didn't die");
isa_ok($row, 'Schema::Result::Product', 'found the row');
is_deeply( $dg->get_elastic_search_insert_data($row), $expected_data, 'elastic search data is correctly generated' );

done_testing;
