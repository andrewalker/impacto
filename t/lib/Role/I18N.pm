package Role::I18N;
use Moose::Role;
use Test::MockObject;

has i18n => (
    is => 'ro',
    isa => 'Locale::Maketext',
    lazy_build => 1,
);

sub _build_i18n {
    my $self = shift;

    my $mock = Test::MockObject->new();
    $mock->set_isa('Locale::Maketext');
    $mock->mock( 'maketext', sub { shift; return @_ } );

    return $mock;
}

no Moose::Role;
1;
