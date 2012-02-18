use utf8;
package Impacto::Schema::Result::FinanceInstallment;

# Created by DBIx::Class::Schema::Loader
# DO NOT MODIFY THE FIRST PART OF THIS FILE

=head1 NAME

Impacto::Schema::Result::FinanceInstallment

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

=head1 TABLE: C<finance.installment>

=cut

__PACKAGE__->table("finance.installment");

=head1 ACCESSORS

=head2 ledger

  data_type: 'integer'
  is_foreign_key: 1
  is_nullable: 0

=head2 due

  data_type: 'date'
  is_nullable: 0

=head2 amount

  data_type: 'money'
  is_nullable: 0

=head2 payed

  data_type: 'boolean'
  default_value: false
  is_nullable: 0

=cut

__PACKAGE__->add_columns(
  "ledger",
  { data_type => "integer", is_foreign_key => 1, is_nullable => 0 },
  "due",
  { data_type => "date", is_nullable => 0 },
  "amount",
  { data_type => "money", is_nullable => 0 },
  "payed",
  { data_type => "boolean", default_value => \"false", is_nullable => 0 },
);

=head1 PRIMARY KEY

=over 4

=item * L</ledger>

=item * L</due>

=back

=cut

__PACKAGE__->set_primary_key("ledger", "due");

=head1 RELATIONS

=head2 installment_payments

Type: has_many

Related object: L<Impacto::Schema::Result::FinanceInstallmentPayment>

=cut

__PACKAGE__->has_many(
  "installment_payments",
  "Impacto::Schema::Result::FinanceInstallmentPayment",
  { "foreign.due" => "self.due", "foreign.ledger" => "self.ledger" },
  { cascade_copy => 0, cascade_delete => 0 },
);

=head2 ledger

Type: belongs_to

Related object: L<Impacto::Schema::Result::FinanceLedger>

=cut

__PACKAGE__->belongs_to(
  "ledger",
  "Impacto::Schema::Result::FinanceLedger",
  { id => "ledger" },
  { is_deferrable => 1, on_delete => "CASCADE", on_update => "CASCADE" },
);


# Created by DBIx::Class::Schema::Loader v0.07015 @ 2012-02-17 22:27:07
# DO NOT MODIFY THIS OR ANYTHING ABOVE! md5sum:2saLPcvoLWnf83ADDmq/BQ


# You can replace this text with custom code or comments, and it will be preserved on regeneration
__PACKAGE__->meta->make_immutable;
1;
