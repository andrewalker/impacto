use warnings;
use strict;
use FindBin '$Bin';
use lib "$Bin/lib";
use Form::Custom;
use Test::More;
use Test::Moose;
use HTML::TreeBuilder;

my $f;
eval { $f = Form::Custom->new };

ok(!$@, "constructor doesn't die");
does_ok($f, 'Impacto::ControllerRole::Form');

has_attribute_ok($f, 'crud_model_instance');
has_attribute_ok($f, 'i18n');
has_attribute_ok($f, 'form_columns');
has_attribute_ok($f, 'form_columns_extra_params');

my $form_columns = [ qw/id name supplier cost/ ];
is_deeply($f->form_columns, $form_columns, 'custom form_columns are correct');

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

is($h_form->look_down(_tag => 'input',  name => 'id')->attr('type'), 'hidden', "The id input is hidden");
is($h_form->look_down(_tag => 'textarea',  name => 'name')->tag, 'textarea', "The name field is textarea");
is($h_form->look_down(_tag => 'select', name => 'supplier')->tag, 'select', "The supplier field is select");

my $h_select = $h_form->look_down(_tag => 'select', name => 'supplier');
is_deeply( [ $h_select->look_down(_tag => 'option', value => 'person1')->content_list ], [ 'André Walker'     ], "First option is correct");
is_deeply( [ $h_select->look_down(_tag => 'option', value => 'person4')->content_list ], [ 'Sir André Walker' ], "Second option is correct");

is($h_form->look_down(_tag => 'input',  name => 'cost')->attr('type'), 'text', "The cost input is text");
ok(!$h_form->look_down(_tag => 'input',  name => 'price'), "There is no price");
is($h_form->look_down(_tag => 'input',  name => 'submit')->attr('type'), 'submit', "The submit input is submit");

done_testing;
