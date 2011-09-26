package Impacto::Schema::Product::Result::Consignation;

# Created by DBIx::Class::Schema::Loader
# DO NOT MODIFY THE FIRST PART OF THIS FILE

use strict;
use warnings;

use Moose;
use MooseX::NonMoose;
use namespace::autoclean;
extends 'DBIx::Class::Core';

__PACKAGE__->load_components("InflateColumn::DateTime");

=head1 NAME

Impacto::Schema::Product::Result::Consignation

=cut

__PACKAGE__->table("consignation");

=head1 ACCESSORS

=head2 id

  data_type: 'integer'
  is_auto_increment: 1
  is_nullable: 0
  sequence: 'product.consignation_id_seq'

=head2 datetime

  data_type: 'timestamp'
  default_value: current_timestamp
  is_nullable: 0
  original: {default_value => \"now()"}

=head2 expected_return

  data_type: 'date'
  is_nullable: 1

=head2 product

  data_type: 'integer'
  is_nullable: 0

=head2 amount

  data_type: 'integer'
  is_nullable: 0

=head2 representant

  data_type: 'text'
  is_nullable: 0

=head2 stock_movement

  data_type: 'integer'
  is_nullable: 0

=cut

__PACKAGE__->add_columns(
  "id",
  {
    data_type         => "integer",
    is_auto_increment => 1,
    is_nullable       => 0,
    sequence          => "product.consignation_id_seq",
  },
  "datetime",
  {
    data_type     => "timestamp",
    default_value => \"current_timestamp",
    is_nullable   => 0,
    original      => { default_value => \"now()" },
  },
  "expected_return",
  { data_type => "date", is_nullable => 1 },
  "product",
  { data_type => "integer", is_nullable => 0 },
  "amount",
  { data_type => "integer", is_nullable => 0 },
  "representant",
  { data_type => "text", is_nullable => 0 },
  "stock_movement",
  { data_type => "integer", is_nullable => 0 },
);
__PACKAGE__->set_primary_key("id");

=head1 RELATIONS

=head2 returns

Type: has_many

Related object: L<Impacto::Schema::Product::Result::Return>

=cut

__PACKAGE__->has_many(
  "returns",
  "Impacto::Schema::Product::Result::Return",
  { "foreign.consignation" => "self.id" },
  { cascade_copy => 0, cascade_delete => 0 },
);


# Created by DBIx::Class::Schema::Loader v0.07010 @ 2011-09-26 20:07:25
# DO NOT MODIFY THIS OR ANYTHING ABOVE! md5sum:19u/4+AFp2cbTIQj0shT7w


# You can replace this text with custom code or comments, and it will be preserved on regeneration
__PACKAGE__->meta->make_immutable;
1;
