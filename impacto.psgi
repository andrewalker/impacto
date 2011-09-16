use strict;
use warnings;

use Impacto;

my $app = Impacto->apply_default_middlewares(Impacto->psgi_app);
$app;

