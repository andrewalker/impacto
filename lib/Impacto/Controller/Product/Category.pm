package Impacto::Controller::Product::Category;
use Moose;
use namespace::autoclean;

BEGIN { extends 'Impacto::ControllerBase::CRUD' }

has '+crud_model_name' => ( default => 'DB::ProductCategory' );

sub datagrid_columns {
    [qw/ parent name /];
}

sub datagrid_columns_extra_params {
    {
        parent => { fk => 'parent.name' }
    }
}

sub form_columns_extra_params {
    {
        slug => { x_field_factory => 'DBIC::Slug', field_source => 'name' },
        parent => { x_field_factory => "DBIC::BelongsTo", option_label => 'name', option_value => 'slug' },
    }
}

__PACKAGE__->meta->make_immutable;

1;

__END__

=encoding utf8

=head1 NAME

Impacto::Controller::Product::Category - Catalyst Controller

=head1 DESCRIPTION

Catalyst Controller.

=head1 METHODS

=head1 AUTHOR

André Walker

=head1 LICENSE

This library is free software. You can redistribute it and/or modify
it under the same terms as Perl itself.
