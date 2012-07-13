#!/usr/bin/env perl
use warnings;
use strict;
use utf8;
use Test::More;
use Form::SensibleX::Field::FileSelector::Catalyst;
use Form::SensibleX::Field::FileSelector::CatalystByteA;
use autodie;

use FindBin '$Bin';
use IO::File;

use Test::MockObject;

my $filename = "file.tmp";
my $fullpath = "$Bin/$filename";
my $contents = "test content";

my $fh_create = IO::File->new;
$fh_create->open("> $fullpath");
print $fh_create $contents;
undef $fh_create;

my $fh = IO::File->new($fullpath);

my $upload = Test::MockObject->new();

$upload->set_isa('Catalyst::Request::Upload');

$upload->mock('fh',       sub { $fh       });
$upload->mock('basename', sub { $filename });
$upload->mock('tempname', sub { $fullpath });

my $field = Form::SensibleX::Field::FileSelector::Catalyst->new(
    name => 'file_upload',
);

isa_ok($field, 'Form::SensibleX::Field::FileSelector::Catalyst');
isa_ok($field, 'Form::Sensible::Field::FileSelector');

ok($field->value($upload), "it's ok to set the value");
is($field->file_ref,  $fh,       'file_ref is correct');
is($field->filename,  $filename, 'filename is correct');
is($field->full_path, $fullpath, 'fullpath is correct');
is($field->tempname,  $fullpath, 'tempname is correct');
is($field->value,     $fullpath, 'value is correct');

my $field_byte_a = Form::SensibleX::Field::FileSelector::CatalystByteA->new(
    name => 'file_upload',
);

isa_ok($field_byte_a, 'Form::SensibleX::Field::FileSelector::CatalystByteA');
isa_ok($field_byte_a, 'Form::SensibleX::Field::FileSelector::Catalyst');
isa_ok($field_byte_a, 'Form::Sensible::Field::FileSelector');

ok($field_byte_a->value($upload), "it's ok to set the value");
is($field_byte_a->file_ref,  $fh,       'file_ref is correct');
is($field_byte_a->filename,  $filename, 'filename is correct');
is($field_byte_a->full_path, $fullpath, 'fullpath is correct');
is($field_byte_a->tempname,  $fullpath, 'tempname is correct');
is($field_byte_a->value,     $contents, 'value is correct (contents)');

unlink $fullpath if -f $fullpath;

done_testing();
