use utf8;
package Impacto::Schema::Result::ProductConsignation;

# Created by DBIx::Class::Schema::Loader
# DO NOT MODIFY THE FIRST PART OF THIS FILE

=head1 NAME

Impacto::Schema::Result::ProductConsignation

=cut

use strict;
use warnings;

=head1 BASE CLASS: L<Impacto::DBIC::Result>

=cut

use Moose;
use MooseX::NonMoose;
use MooseX::MarkAsMethods autoclean => 1;
extends 'Impacto::DBIC::Result';

=head1 COMPONENTS LOADED

=over 4

=item * L<DBIx::Class::InflateColumn::DateTime>

=back

=cut

__PACKAGE__->load_components("InflateColumn::DateTime");

=head1 TABLE: C<product.consignation>

=cut

__PACKAGE__->table("product.consignation");

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
  is_foreign_key: 1
  is_nullable: 0

=head2 stock_movement

  data_type: 'integer'
  is_foreign_key: 1
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
  { data_type => "text", is_foreign_key => 1, is_nullable => 0 },
  "stock_movement",
  { data_type => "integer", is_foreign_key => 1, is_nullable => 0 },
);

=head1 PRIMARY KEY

=over 4

=item * L</id>

=back

=cut

__PACKAGE__->set_primary_key("id");

=head1 RELATIONS

=head2 representant

Type: belongs_to

Related object: L<Impacto::Schema::Result::PeopleRepresentant>

=cut

__PACKAGE__->belongs_to(
  "representant",
  "Impacto::Schema::Result::PeopleRepresentant",
  { person => "representant" },
  { is_deferrable => 1, on_delete => "CASCADE", on_update => "CASCADE" },
);

=head2 returns

Type: has_many

Related object: L<Impacto::Schema::Result::ProductReturn>

=cut

__PACKAGE__->has_many(
  "returns",
  "Impacto::Schema::Result::ProductReturn",
  { "foreign.consignation" => "self.id" },
  { cascade_copy => 0, cascade_delete => 0 },
);

=head2 stock_movement

Type: belongs_to

Related object: L<Impacto::Schema::Result::ProductStockMovement>

=cut

__PACKAGE__->belongs_to(
  "stock_movement",
  "Impacto::Schema::Result::ProductStockMovement",
  { id => "stock_movement" },
  { is_deferrable => 1, on_delete => "CASCADE", on_update => "CASCADE" },
);


# Created by DBIx::Class::Schema::Loader v0.07015 @ 2012-02-17 22:27:07
# DO NOT MODIFY THIS OR ANYTHING ABOVE! md5sum:waP9ZveuO/BA1/Xy/jMM8Q


# You can replace this text with custom code or comments, and it will be preserved on regeneration
__PACKAGE__->meta->make_immutable;
1;
