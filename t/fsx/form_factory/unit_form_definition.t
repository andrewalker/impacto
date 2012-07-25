#!/usr/bin/env perl
use warnings;
use strict;
use Test::More;
use Form::SensibleX::FormFactory::FormDefinition;
use FindBin '$Bin';
use Config::General;

{
    my %sample = (
        foo => 'bar',
        bar => 'baz',
    );
    ok(my $form_def = Form::SensibleX::FormFactory::FormDefinition->new(
        path_to_forms => $Bin,
        form_name     => 'foobar',
    ), 'instantiated');
    isa_ok($form_def, 'Form::SensibleX::FormFactory::FormDefinition');
    can_ok($form_def, 'save');
    eval { $form_def->save(\%sample) };
    ok(!$@, 'save executes ok');
}

{
    ok(-e "$Bin/foobar.conf", 'config file was created');
    my $conf = Config::General->new("$Bin/foobar.conf");
    is_deeply({ $conf->getall }, { foo => 'bar', bar => 'baz' }, 'config was saved ok');
}

{
    ok(my $form_def = Form::SensibleX::FormFactory::FormDefinition->new(
        path_to_forms => $Bin,
        form_name     => 'foobar',
    ), 'instantiated');
    isa_ok($form_def, 'Form::SensibleX::FormFactory::FormDefinition');
    can_ok($form_def, 'load');
    my $loaded_def;
    eval { $loaded_def = $form_def->load() };
    ok(!$@, 'load executes ok');
    is_deeply($loaded_def, { foo => 'bar', bar => 'baz' }, 'config was loaded ok');
}

unlink "$Bin/foobar.conf";

done_testing;
