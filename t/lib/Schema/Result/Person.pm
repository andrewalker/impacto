use utf8;
package Schema::Result::Person;

# Created by DBIx::Class::Schema::Loader
# DO NOT MODIFY THE FIRST PART OF THIS FILE

=head1 NAME

Schema::Result::Person

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

=head1 TABLE: C<person>

=cut

__PACKAGE__->table("person");

=head1 ACCESSORS

=head2 slug

  data_type: 'text'
  is_nullable: 0

=head2 name

  data_type: 'text'
  is_nullable: 0

=head2 birthday

  data_type: 'timestamp'
  default_value: current_timestamp
  is_nullable: 0

=head2 phone

  data_type: 'text'
  is_nullable: 1

=head2 email

  data_type: 'text'
  is_nullable: 1

=cut

__PACKAGE__->add_columns(
  "slug",
  { data_type => "text", is_nullable => 0 },
  "name",
  { data_type => "text", is_nullable => 0 },
  "birthday",
  {
    data_type     => "timestamp",
    default_value => \"current_timestamp",
    is_nullable   => 0,
  },
  "phone",
  { data_type => "text", is_nullable => 1 },
  "email",
  { data_type => "text", is_nullable => 1 },
);

=head1 PRIMARY KEY

=over 4

=item * L</slug>

=back

=cut

__PACKAGE__->set_primary_key("slug");

=head1 RELATIONS

=head2 supplier

Type: might_have

Related object: L<Schema::Result::Supplier>

=cut

__PACKAGE__->might_have(
  "supplier",
  "Schema::Result::Supplier",
  { "foreign.person" => "self.slug" },
  { cascade_copy => 0, cascade_delete => 0 },
);


# Created by DBIx::Class::Schema::Loader v0.07015 @ 2012-02-10 19:52:03
# DO NOT MODIFY THIS OR ANYTHING ABOVE! md5sum:r8r3TSGRnLZj4XmhaAkj/Q


# You can replace this text with custom code or comments, and it will be preserved on regeneration
1;
