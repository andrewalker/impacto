use utf8;
package Schema::Result::Category;

# Created by DBIx::Class::Schema::Loader
# DO NOT MODIFY THE FIRST PART OF THIS FILE

=head1 NAME

Schema::Result::Category

=cut

use strict;
use warnings;

=head1 BASE CLASS: L<Impacto::DBIC::Result>

=cut

use base 'Impacto::DBIC::Result';

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

=head2 name

  data_type: 'text'
  is_nullable: 0

=cut

__PACKAGE__->add_columns(
  "slug",
  { data_type => "text", is_nullable => 0 },
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

=head2 product_categories

Type: has_many

Related object: L<Schema::Result::ProductCategory>

=cut

__PACKAGE__->has_many(
  "product_categories",
  "Schema::Result::ProductCategory",
  { "foreign.category" => "self.slug" },
  { cascade_copy => 0, cascade_delete => 0 },
);

=head2 products

Type: many_to_many

Composing rels: L</product_categories> -> product

=cut

__PACKAGE__->many_to_many("products", "product_categories", "product");


# Created by DBIx::Class::Schema::Loader v0.07025 @ 2012-07-13 01:40:59
# DO NOT MODIFY THIS OR ANYTHING ABOVE! md5sum:FjeHiDwOQ66GAc3NzhmWnQ


# You can replace this text with custom code or comments, and it will be preserved on regeneration
1;
