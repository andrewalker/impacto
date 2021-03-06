use utf8;
package Schema::Result::ProductCategory;

# Created by DBIx::Class::Schema::Loader
# DO NOT MODIFY THE FIRST PART OF THIS FILE

=head1 NAME

Schema::Result::ProductCategory

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

=head1 TABLE: C<product_category>

=cut

__PACKAGE__->table("product_category");

=head1 ACCESSORS

=head2 product

  data_type: 'integer'
  is_foreign_key: 1
  is_nullable: 0

=head2 category

  data_type: 'text'
  is_foreign_key: 1
  is_nullable: 0

=cut

__PACKAGE__->add_columns(
  "product",
  { data_type => "integer", is_foreign_key => 1, is_nullable => 0 },
  "category",
  { data_type => "text", is_foreign_key => 1, is_nullable => 0 },
);

=head1 PRIMARY KEY

=over 4

=item * L</product>

=item * L</category>

=back

=cut

__PACKAGE__->set_primary_key("product", "category");

=head1 RELATIONS

=head2 category

Type: belongs_to

Related object: L<Schema::Result::Category>

=cut

__PACKAGE__->belongs_to(
  "category",
  "Schema::Result::Category",
  { slug => "category" },
  { is_deferrable => 1, on_delete => "CASCADE", on_update => "CASCADE" },
);

=head2 product

Type: belongs_to

Related object: L<Schema::Result::Product>

=cut

__PACKAGE__->belongs_to(
  "product",
  "Schema::Result::Product",
  { id => "product" },
  { is_deferrable => 1, on_delete => "CASCADE", on_update => "CASCADE" },
);

=head2 product_category_comment

Type: might_have

Related object: L<Schema::Result::ProductCategoryComment>

=cut

__PACKAGE__->might_have(
  "product_category_comment",
  "Schema::Result::ProductCategoryComment",
  {
    "foreign.category" => "self.category",
    "foreign.product"  => "self.product",
  },
  { cascade_copy => 0, cascade_delete => 0 },
);


# Created by DBIx::Class::Schema::Loader v0.07025 @ 2012-07-13 17:33:10
# DO NOT MODIFY THIS OR ANYTHING ABOVE! md5sum:PxEcZa/08pejw9denoPqDg


# You can replace this text with custom code or comments, and it will be preserved on regeneration
1;
