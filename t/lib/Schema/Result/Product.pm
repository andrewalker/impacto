use utf8;
package Schema::Result::Product;

# Created by DBIx::Class::Schema::Loader
# DO NOT MODIFY THE FIRST PART OF THIS FILE

=head1 NAME

Schema::Result::Product

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

=head1 TABLE: C<product>

=cut

__PACKAGE__->table("product");

=head1 ACCESSORS

=head2 id

  data_type: 'integer'
  is_auto_increment: 1
  is_nullable: 0

=head2 name

  data_type: 'text'
  is_nullable: 0

=head2 supplier

  data_type: 'text'
  is_foreign_key: 1
  is_nullable: 1

=head2 cost

  data_type: 'money'
  is_nullable: 0

=head2 price

  data_type: 'money'
  is_nullable: 0

=cut

__PACKAGE__->add_columns(
  "id",
  { data_type => "integer", is_auto_increment => 1, is_nullable => 0 },
  "name",
  { data_type => "text", is_nullable => 0 },
  "supplier",
  { data_type => "text", is_foreign_key => 1, is_nullable => 1 },
  "cost",
  { data_type => "money", is_nullable => 0 },
  "price",
  { data_type => "money", is_nullable => 0 },
);

=head1 PRIMARY KEY

=over 4

=item * L</id>

=back

=cut

__PACKAGE__->set_primary_key("id");

=head1 RELATIONS

=head2 supplier

Type: belongs_to

Related object: L<Schema::Result::Supplier>

=cut

__PACKAGE__->belongs_to(
  "supplier",
  "Schema::Result::Supplier",
  { person => "supplier" },
  {
    is_deferrable => 1,
    join_type     => "LEFT",
    on_delete     => "CASCADE",
    on_update     => "CASCADE",
  },
);


# Created by DBIx::Class::Schema::Loader v0.07015 @ 2012-02-14 18:27:46
# DO NOT MODIFY THIS OR ANYTHING ABOVE! md5sum:Zv/Jf8Vl4TfvCkzjXYFo3Q


# You can replace this text with custom code or comments, and it will be preserved on regeneration
1;
