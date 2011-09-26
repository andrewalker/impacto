package Impacto::Schema::Product::Result::Return;

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

Impacto::Schema::Product::Result::Return

=cut

__PACKAGE__->table("return");

=head1 ACCESSORS

=head2 id

  data_type: 'integer'
  is_auto_increment: 1
  is_nullable: 0
  sequence: 'product.return_id_seq'

=head2 datetime

  data_type: 'timestamp'
  default_value: current_timestamp
  is_nullable: 0
  original: {default_value => \"now()"}

=head2 consignation

  data_type: 'integer'
  is_foreign_key: 1
  is_nullable: 0

=head2 amount

  data_type: 'integer'
  is_nullable: 0

=head2 stock_movement

  data_type: 'integer'
  is_foreign_key: 1
  is_nullable: 1

=head2 ledger

  data_type: 'integer'
  is_nullable: 1

=cut

__PACKAGE__->add_columns(
  "id",
  {
    data_type         => "integer",
    is_auto_increment => 1,
    is_nullable       => 0,
    sequence          => "product.return_id_seq",
  },
  "datetime",
  {
    data_type     => "timestamp",
    default_value => \"current_timestamp",
    is_nullable   => 0,
    original      => { default_value => \"now()" },
  },
  "consignation",
  { data_type => "integer", is_foreign_key => 1, is_nullable => 0 },
  "amount",
  { data_type => "integer", is_nullable => 0 },
  "stock_movement",
  { data_type => "integer", is_foreign_key => 1, is_nullable => 1 },
  "ledger",
  { data_type => "integer", is_nullable => 1 },
);
__PACKAGE__->set_primary_key("id");

=head1 RELATIONS

=head2 consignation

Type: belongs_to

Related object: L<Impacto::Schema::Product::Result::Consignation>

=cut

__PACKAGE__->belongs_to(
  "consignation",
  "Impacto::Schema::Product::Result::Consignation",
  { id => "consignation" },
  { is_deferrable => 1, on_delete => "CASCADE", on_update => "CASCADE" },
);

=head2 stock_movement

Type: belongs_to

Related object: L<Impacto::Schema::Product::Result::StockMovement>

=cut

__PACKAGE__->belongs_to(
  "stock_movement",
  "Impacto::Schema::Product::Result::StockMovement",
  { id => "stock_movement" },
  {
    is_deferrable => 1,
    join_type     => "LEFT",
    on_delete     => "CASCADE",
    on_update     => "CASCADE",
  },
);


# Created by DBIx::Class::Schema::Loader v0.07010 @ 2011-09-26 20:07:25
# DO NOT MODIFY THIS OR ANYTHING ABOVE! md5sum:WvHz0359EybZ+TXx67C7/A


# You can replace this text with custom code or comments, and it will be preserved on regeneration
__PACKAGE__->meta->make_immutable;
1;
