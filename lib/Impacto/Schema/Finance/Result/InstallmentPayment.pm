package Impacto::Schema::Finance::Result::InstallmentPayment;

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

Impacto::Schema::Finance::Result::InstallmentPayment

=cut

__PACKAGE__->table("installment_payment");

=head1 ACCESSORS

=head2 id

  data_type: 'integer'
  is_auto_increment: 1
  is_nullable: 0
  sequence: 'finance.installment_payment_id_seq'

=head2 ledger

  data_type: 'integer'
  is_nullable: 1

=head2 due

  data_type: 'date'
  is_nullable: 1

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
  { data_type => "integer", is_nullable => 1 },
  "due",
  { data_type => "date", is_nullable => 1 },
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


# Created by DBIx::Class::Schema::Loader v0.07010 @ 2011-09-26 20:07:27
# DO NOT MODIFY THIS OR ANYTHING ABOVE! md5sum:G36lPjOwmtTFtKpN0KsYIw


# You can replace this text with custom code or comments, and it will be preserved on regeneration
__PACKAGE__->meta->make_immutable;
1;
