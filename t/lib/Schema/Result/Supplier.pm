use utf8;
package Schema::Result::Supplier;

# Created by DBIx::Class::Schema::Loader
# DO NOT MODIFY THE FIRST PART OF THIS FILE

=head1 NAME

Schema::Result::Supplier

=cut

use strict;
use warnings;

use base 'DBIx::Class::Core';

=head1 COMPONENTS LOADED

=over 4

=item * L<DBIx::Class::InflateColumn::DateTime>

=back

=cut

__PACKAGE__->load_components("InflateColumn::DateTime");

=head1 TABLE: C<supplier>

=cut

__PACKAGE__->table("supplier");

=head1 ACCESSORS

=head2 person

  data_type: 'text'
  is_foreign_key: 1
  is_nullable: 0

=cut

__PACKAGE__->add_columns(
  "person",
  { data_type => "text", is_foreign_key => 1, is_nullable => 0 },
);

=head1 PRIMARY KEY

=over 4

=item * L</person>

=back

=cut

__PACKAGE__->set_primary_key("person");

=head1 RELATIONS

=head2 person

Type: belongs_to

Related object: L<Schema::Result::Person>

=cut

__PACKAGE__->belongs_to(
  "person",
  "Schema::Result::Person",
  { slug => "person" },
  { is_deferrable => 1, on_delete => "CASCADE", on_update => "CASCADE" },
);

=head2 products

Type: has_many

Related object: L<Schema::Result::Product>

=cut

__PACKAGE__->has_many(
  "products",
  "Schema::Result::Product",
  { "foreign.supplier" => "self.person" },
  { cascade_copy => 0, cascade_delete => 0 },
);


# Created by DBIx::Class::Schema::Loader v0.07015 @ 2012-02-10 19:52:03
# DO NOT MODIFY THIS OR ANYTHING ABOVE! md5sum:+N4AMo9SVjNtep3Cd0k5TA


# You can replace this text with custom code or comments, and it will be preserved on regeneration
1;
