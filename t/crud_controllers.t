use warnings;
use strict;
use Test::More;
use Test::WWW::Mechanize::Catalyst;
use Impacto;

my $mech = Test::WWW::Mechanize::Catalyst->new(catalyst_app => 'Impacto');

my $c = new Impacto();
foreach my $controller ($c->controllers) {
    $controller = $c->controller($controller);
    next unless $controller->isa('Impacto::ControllerBase::CRUD');

    my $namespace = '/' . $controller->action_namespace($c);

    diag "Testing $namespace";

    $mech->get_ok($namespace);
    is($mech->ct, "text/html");
    $mech->get_ok($namespace . "/create");
    is($mech->ct, "text/html");
}

done_testing;
