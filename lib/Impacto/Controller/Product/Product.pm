package Impacto::Controller::Product::Product;
use Moose;
use namespace::autoclean;

BEGIN { extends 'Impacto::ControllerBase::CRUD' }

sub form_columns {
    [qw/
        name supplier cost minimum_price price weight image
    /]
}
sub form_columns_extra_params {
    {
        supplier => { x_field_class => "ForeignKey::DBIC", option_label => 'person', option_value => 'person' },
        image    => { x_field_class => 'FileSelector::CatalystByteA' },
    }
}

sub _build_datagrid_columns {
    [qw/
        name supplier cost minimum_price price weight
    /]
}

has '+crud_model_name' => ( default => 'DB::ProductProduct' );

=head1 NAME

Impacto::Controller::Product::Product - Catalyst Controller

=head1 DESCRIPTION

Catalyst Controller.

=head1 METHODS

=cut


=head1 AUTHOR

André Walker

=head1 LICENSE

This library is free software. You can redistribute it and/or modify
it under the same terms as Perl itself.

=cut

__PACKAGE__->meta->make_immutable;

1;
