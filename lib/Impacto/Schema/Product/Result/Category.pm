use utf8;
package Impacto::Schema::Product::Result::Category;

# Created by DBIx::Class::Schema::Loader
# DO NOT MODIFY THE FIRST PART OF THIS FILE

=head1 NAME

Impacto::Schema::Product::Result::Category

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

=head1 TABLE: C<category>

=cut

__PACKAGE__->table("category");

=head1 ACCESSORS

=head2 slug

  data_type: 'text'
  is_nullable: 0

=head2 parent

  data_type: 'text'
  is_foreign_key: 1
  is_nullable: 1

=head2 name

  data_type: 'text'
  is_nullable: 0

=cut

__PACKAGE__->add_columns(
  "slug",
  { data_type => "text", is_nullable => 0 },
  "parent",
  { data_type => "text", is_foreign_key => 1, is_nullable => 1 },
  "name",
  { data_type => "text", is_nullable => 0 },
);

=head1 PRIMARY KEY

=over 4

=item * L</slug>

=back

=cut

__PACKAGE__->set_primary_key("slug");

=head1 RELATIONS

=head2 categories

Type: has_many

Related object: L<Impacto::Schema::Product::Result::Category>

=cut

__PACKAGE__->has_many(
  "categories",
  "Impacto::Schema::Product::Result::Category",
  { "foreign.parent" => "self.slug" },
  { cascade_copy => 0, cascade_delete => 0 },
);

=head2 parent

Type: belongs_to

Related object: L<Impacto::Schema::Product::Result::Category>

=cut

__PACKAGE__->belongs_to(
  "parent",
  "Impacto::Schema::Product::Result::Category",
  { slug => "parent" },
  {
    is_deferrable => 1,
    join_type     => "LEFT",
    on_delete     => "CASCADE",
    on_update     => "CASCADE",
  },
);

=head2 product_categories

Type: has_many

Related object: L<Impacto::Schema::Product::Result::ProductCategory>

=cut

__PACKAGE__->has_many(
  "product_categories",
  "Impacto::Schema::Product::Result::ProductCategory",
  { "foreign.category" => "self.slug" },
  { cascade_copy => 0, cascade_delete => 0 },
);

=head2 products

Type: many_to_many

Composing rels: L</product_categories> -> product

=cut

__PACKAGE__->many_to_many("products", "product_categories", "product");


# Created by DBIx::Class::Schema::Loader v0.07015 @ 2012-02-17 15:36:57
# DO NOT MODIFY THIS OR ANYTHING ABOVE! md5sum:pbWKv6rgvYpkPOasUqk/3g


# You can replace this text with custom code or comments, and it will be preserved on regeneration
__PACKAGE__->meta->make_immutable;
1;
