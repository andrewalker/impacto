use warnings;
use strict;
use Test::More;
use Test::WWW::Mechanize::Catalyst;
use Impacto;

my $mech = Test::WWW::Mechanize::Catalyst->new(catalyst_app => 'Impacto');
$mech->get('/login');
$mech->submit_form(fields => { username => 'admin', password => 'admin' });

my $c = new Impacto();
foreach my $controller ($c->controllers) {
    $controller = $c->controller($controller);
    next unless $controller->isa('Impacto::ControllerBase::CRUD');

    my $namespace = '/' . $controller->action_namespace($c);

    $mech->get_ok($namespace);
    $mech->content_like(qr/datagrid_table/, "$namespace has a table");
    $mech->content_like(qr/search/, "$namespace has a search form");

    $mech->get_ok($namespace . "/create");
    $mech->content_like(qr/fs_form/, "$namespace/create has a Form::Sensible form");
}

done_testing;
