use strict;
use warnings;
use Test::More;

use Pod::Coverage;
use Test::Pod::Coverage;

my @modules = all_modules;

foreach my $module (@modules) {
    pod_coverage_ok($module, {
        coverage_class => 'Pod::Coverage::TrustPod',
    });
}

done_testing;

