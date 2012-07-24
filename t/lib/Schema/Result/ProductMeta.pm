use utf8;
package Schema::Result::ProductMeta;

# Created by DBIx::Class::Schema::Loader
# DO NOT MODIFY THE FIRST PART OF THIS FILE

=head1 NAME

Schema::Result::ProductMeta

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

=head1 TABLE: C<product_meta>

=cut

__PACKAGE__->table("product_meta");

=head1 ACCESSORS

=head2 product

  data_type: 'integer'
  is_foreign_key: 1
  is_nullable: 0

=head2 name

  data_type: 'text'
  is_nullable: 0

=head2 value

  data_type: 'text'
  is_nullable: 0

=cut

__PACKAGE__->add_columns(
  "product",
  { data_type => "integer", is_foreign_key => 1, is_nullable => 0 },
  "name",
  { data_type => "text", is_nullable => 0 },
  "value",
  { data_type => "text", is_nullable => 0 },
);

=head1 PRIMARY KEY

=over 4

=item * L</product>

=item * L</name>

=back

=cut

__PACKAGE__->set_primary_key("product", "name");

=head1 RELATIONS

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


# Created by DBIx::Class::Schema::Loader v0.07025 @ 2012-07-24 17:11:10
# DO NOT MODIFY THIS OR ANYTHING ABOVE! md5sum:50wh4wqcMlroDOtY56OpqA


# You can replace this text with custom code or comments, and it will be preserved on regeneration
1;
