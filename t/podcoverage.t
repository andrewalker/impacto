use strict;
use warnings;
use Test::More;

use Pod::Coverage;
use Test::Pod::Coverage;

my @modules = all_modules;

my @private = qw/
    BUILD
/;

my @trustme = qw/
    datagrid_columns
    datagrid_columns_extra_params
    form_columns
    form_columns_extra_params
/;

foreach my $module (@modules) {
    pod_coverage_ok($module, {
        coverage_class => 'Pod::Coverage::Moose',
        also_private => [
            map { qr/^$_$/ } @private
        ],
        trustme => [
            map { qr/^$_$/ } @trustme
        ],
    });
}

done_testing;

