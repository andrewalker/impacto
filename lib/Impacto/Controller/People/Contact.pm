package Impacto::Controller::People::Contact;
use Moose;
use namespace::autoclean;

BEGIN { extends 'Impacto::ControllerBase::CRUD' }

has '+crud_model_name' => ( default => 'DB::PeopleContact' );

sub datagrid_columns {
    [qw/ date client answered type /];
}

sub datagrid_columns_extra_params {
    {
        client => { fk => 'client.person.name' }
    }
}

sub form_columns_extra_params {
    {
        client   => { x_field_factory => "DBIC::BelongsTo", option_label => 'person.name', option_value => 'person', },
        abstract => { field_class => 'LongText' },
    }
}

__PACKAGE__->meta->make_immutable;

1;

__END__

=encoding utf8

=head1 NAME

Impacto::Controller::People::Contact - Catalyst Controller

=head1 DESCRIPTION

Catalyst Controller.

=head1 METHODS

=head1 AUTHOR

André Walker

=head1 LICENSE

This library is free software. You can redistribute it and/or modify
it under the same terms as Perl itself.
