use utf8;
package Schema::Result::ProductCategoryComment;

# Created by DBIx::Class::Schema::Loader
# DO NOT MODIFY THE FIRST PART OF THIS FILE

=head1 NAME

Schema::Result::ProductCategoryComment

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

=head1 TABLE: C<product_category_comments>

=cut

__PACKAGE__->table("product_category_comments");

=head1 ACCESSORS

=head2 product

  data_type: 'integer'
  is_foreign_key: 1
  is_nullable: 0

=head2 category

  data_type: 'text'
  is_foreign_key: 1
  is_nullable: 0

=head2 comments

  data_type: 'text'
  is_nullable: 0

=cut

__PACKAGE__->add_columns(
  "product",
  { data_type => "integer", is_foreign_key => 1, is_nullable => 0 },
  "category",
  { data_type => "text", is_foreign_key => 1, is_nullable => 0 },
  "comments",
  { data_type => "text", is_nullable => 0 },
);

=head1 PRIMARY KEY

=over 4

=item * L</product>

=item * L</category>

=back

=cut

__PACKAGE__->set_primary_key("product", "category");

=head1 RELATIONS

=head2 product_category

Type: belongs_to

Related object: L<Schema::Result::ProductCategory>

=cut

__PACKAGE__->belongs_to(
  "product_category",
  "Schema::Result::ProductCategory",
  { category => "category", product => "product" },
  { is_deferrable => 1, on_delete => "CASCADE", on_update => "CASCADE" },
);


# Created by DBIx::Class::Schema::Loader v0.07025 @ 2012-07-13 17:33:10
# DO NOT MODIFY THIS OR ANYTHING ABOVE! md5sum:nwIt2cc0Xy98pkuSnA3krQ


# You can replace this text with custom code or comments, and it will be preserved on regeneration
1;
