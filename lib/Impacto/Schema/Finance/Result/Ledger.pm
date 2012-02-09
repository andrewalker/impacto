use utf8;
package Impacto::Schema::Finance::Result::Ledger;

# Created by DBIx::Class::Schema::Loader
# DO NOT MODIFY THE FIRST PART OF THIS FILE

=head1 NAME

Impacto::Schema::Finance::Result::Ledger

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

=head1 TABLE: C<ledger>

=cut

__PACKAGE__->table("ledger");

=head1 ACCESSORS

=head2 id

  data_type: 'integer'
  is_auto_increment: 1
  is_nullable: 0
  sequence: 'finance.ledger_id_seq'

=head2 ledger_type

  data_type: 'text'
  is_foreign_key: 1
  is_nullable: 0

=head2 account

  data_type: 'text'
  is_foreign_key: 1
  is_nullable: 0

=head2 value

  data_type: 'money'
  is_nullable: 0

=head2 datetime

  data_type: 'timestamp'
  is_nullable: 0

=head2 stock_movement

  data_type: 'integer'
  is_nullable: 1

=head2 comment

  data_type: 'text'
  is_nullable: 1

=cut

__PACKAGE__->add_columns(
  "id",
  {
    data_type         => "integer",
    is_auto_increment => 1,
    is_nullable       => 0,
    sequence          => "finance.ledger_id_seq",
  },
  "ledger_type",
  { data_type => "text", is_foreign_key => 1, is_nullable => 0 },
  "account",
  { data_type => "text", is_foreign_key => 1, is_nullable => 0 },
  "value",
  { data_type => "money", is_nullable => 0 },
  "datetime",
  { data_type => "timestamp", is_nullable => 0 },
  "stock_movement",
  { data_type => "integer", is_nullable => 1 },
  "comment",
  { data_type => "text", is_nullable => 1 },
);

=head1 PRIMARY KEY

=over 4

=item * L</id>

=back

=cut

__PACKAGE__->set_primary_key("id");

=head1 RELATIONS

=head2 account

Type: belongs_to

Related object: L<Impacto::Schema::Finance::Result::Account>

=cut

__PACKAGE__->belongs_to(
  "account",
  "Impacto::Schema::Finance::Result::Account",
  { name => "account" },
  { is_deferrable => 1, on_delete => "CASCADE", on_update => "CASCADE" },
);

=head2 installments

Type: has_many

Related object: L<Impacto::Schema::Finance::Result::Installment>

=cut

__PACKAGE__->has_many(
  "installments",
  "Impacto::Schema::Finance::Result::Installment",
  { "foreign.ledger" => "self.id" },
  { cascade_copy => 0, cascade_delete => 0 },
);

=head2 ledger_type

Type: belongs_to

Related object: L<Impacto::Schema::Finance::Result::LedgerType>

=cut

__PACKAGE__->belongs_to(
  "ledger_type",
  "Impacto::Schema::Finance::Result::LedgerType",
  { slug => "ledger_type" },
  { is_deferrable => 1, on_delete => "CASCADE", on_update => "CASCADE" },
);


# Created by DBIx::Class::Schema::Loader v0.07015 @ 2012-02-09 16:32:11
# DO NOT MODIFY THIS OR ANYTHING ABOVE! md5sum:GffeA4kHTHV7/tdgnFFOhw


# You can replace this text with custom code or comments, and it will be preserved on regeneration
__PACKAGE__->meta->make_immutable;
1;
