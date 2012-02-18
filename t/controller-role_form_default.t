use warnings;
use strict;
use FindBin '$Bin';
use lib "$Bin/lib";
use Form::Default;
use Test::More;
use Test::Moose;
use HTML::TreeBuilder;

my $f;
eval { $f = Form::Default->new };

ok(!$@, "constructor doesn't die");
does_ok($f, 'Impacto::ControllerRole::Form');

has_attribute_ok($f, 'crud_model_instance');
has_attribute_ok($f, 'i18n');
has_attribute_ok($f, 'form_columns');
has_attribute_ok($f, 'form_columns_extra_params');

my $form_columns = [ qw/id name supplier cost price/ ];
my $extra_params = {};

is_deeply($f->form_columns, $form_columns, 'default form_columns are correct');
is_deeply($f->form_columns_extra_params, $extra_params, 'default form_columns_extra_params are correct');

my $generated_form;
eval { $generated_form = $f->build_form_sensible_object };

ok(!$@, "build_form_sensible_object doesn't die");
isa_ok($generated_form, 'Form::Sensible::Form');

my $form_html;
eval { $form_html = $f->render_form($generated_form) };
ok(!$@, 'render_form() does not die');
ok($form_html, 'returns a true value');

my $h = HTML::TreeBuilder->new;
$h->parse_content( $form_html );

# just checking some expected html elements are there, and have correct types
# (leave thorough testing for FS::Renderer::HTML test suite)
my $h_form = $h->find('form');
is($h_form->tag, 'form', "there is a <form> tag in the generated html");

is($h_form->look_down(_tag => 'input', name => 'id')->attr('type'), 'hidden', "The id input is hidden");
is($h_form->look_down(_tag => 'input', name => 'name')->attr('type'), 'text', "The name input is text");
is($h_form->look_down(_tag => 'input', name => 'supplier')->attr('type'), 'text', "The supplier input is text");
is($h_form->look_down(_tag => 'input', name => 'cost')->attr('type'), 'text', "The cost input is text");
is($h_form->look_down(_tag => 'input', name => 'price')->attr('type'), 'text', "The price input is text");
is($h_form->look_down(_tag => 'input', name => 'submit')->attr('type'), 'submit', "The submit input is submit");

done_testing;
