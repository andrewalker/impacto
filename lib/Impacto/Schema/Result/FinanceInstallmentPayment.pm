use utf8;
package Impacto::Schema::Result::FinanceInstallmentPayment;

# Created by DBIx::Class::Schema::Loader
# DO NOT MODIFY THE FIRST PART OF THIS FILE

=head1 NAME

Impacto::Schema::Result::FinanceInstallmentPayment

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

=head1 TABLE: C<finance.installment_payment>

=cut

__PACKAGE__->table("finance.installment_payment");

=head1 ACCESSORS

=head2 id

  data_type: 'integer'
  is_auto_increment: 1
  is_nullable: 0
  sequence: 'finance.installment_payment_id_seq'

=head2 ledger

  data_type: 'integer'
  is_foreign_key: 1
  is_nullable: 0

=head2 due

  data_type: 'date'
  is_foreign_key: 1
  is_nullable: 0

=head2 date

  data_type: 'date'
  default_value: current_timestamp
  is_nullable: 0
  original: {default_value => \"now()"}

=head2 amount

  data_type: 'money'
  is_nullable: 0

=head2 account

  data_type: 'text'
  is_foreign_key: 1
  is_nullable: 0

=head2 payment_method

  data_type: 'text'
  is_nullable: 1

=head2 comments

  data_type: 'text'
  is_nullable: 1

=cut

__PACKAGE__->add_columns(
  "id",
  {
    data_type         => "integer",
    is_auto_increment => 1,
    is_nullable       => 0,
    sequence          => "finance.installment_payment_id_seq",
  },
  "ledger",
  { data_type => "integer", is_foreign_key => 1, is_nullable => 0 },
  "due",
  { data_type => "date", is_foreign_key => 1, is_nullable => 0 },
  "date",
  {
    data_type     => "date",
    default_value => \"current_timestamp",
    is_nullable   => 0,
    original      => { default_value => \"now()" },
  },
  "amount",
  { data_type => "money", is_nullable => 0 },
  "account",
  { data_type => "text", is_foreign_key => 1, is_nullable => 0 },
  "payment_method",
  { data_type => "text", is_nullable => 1 },
  "comments",
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

Related object: L<Impacto::Schema::Result::FinanceAccount>

=cut

__PACKAGE__->belongs_to(
  "account",
  "Impacto::Schema::Result::FinanceAccount",
  { name => "account" },
  { is_deferrable => 1, on_delete => "CASCADE", on_update => "CASCADE" },
);

=head2 installment

Type: belongs_to

Related object: L<Impacto::Schema::Result::FinanceInstallment>

=cut

__PACKAGE__->belongs_to(
  "installment",
  "Impacto::Schema::Result::FinanceInstallment",
  { due => "due", ledger => "ledger" },
  { is_deferrable => 1, on_delete => "CASCADE", on_update => "CASCADE" },
);


# Created by DBIx::Class::Schema::Loader v0.07015 @ 2012-02-17 22:27:07
# DO NOT MODIFY THIS OR ANYTHING ABOVE! md5sum:fYS82nBdUqquqrHIH9tRfg


# You can replace this text with custom code or comments, and it will be preserved on regeneration
__PACKAGE__->meta->make_immutable;
1;
