package Impacto::Schema::Finance::Result::LedgerType;

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

Impacto::Schema::Finance::Result::LedgerType

=cut

__PACKAGE__->table("ledger_type");

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
__PACKAGE__->set_primary_key("slug");

=head1 RELATIONS

=head2 ledgers

Type: has_many

Related object: L<Impacto::Schema::Finance::Result::Ledger>

=cut

__PACKAGE__->has_many(
  "ledgers",
  "Impacto::Schema::Finance::Result::Ledger",
  { "foreign.ledger_type" => "self.slug" },
  { cascade_copy => 0, cascade_delete => 0 },
);


# Created by DBIx::Class::Schema::Loader v0.07010 @ 2011-09-26 20:07:27
# DO NOT MODIFY THIS OR ANYTHING ABOVE! md5sum:3mt/E1E7RgE45RDlPK8Vmw


# You can replace this text with custom code or comments, and it will be preserved on regeneration
__PACKAGE__->meta->make_immutable;
1;
