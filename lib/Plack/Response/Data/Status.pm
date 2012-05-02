package Plack::Response::Data::Status;
use strict;
use warnings;
use base 'Plack::Response::Data';

use HTTP::Status ();

sub mime_type {
    'text/plain';
}

sub encode {
    my $self = shift;
    my $code = shift or return;
    my $mess = HTTP::Status::status_message($code);
    $mess =~ s/\s*$/\015\012/s;
    $mess;
}

sub code {
    my $self = shift;
    return $self->SUPER::code unless @_;
    $self->SUPER::data(@_);
    $self->SUPER::code(@_);
}

sub status {
    my $self = shift;
    return $self->SUPER::status unless @_;
    $self->SUPER::data(@_);
    $self->SUPER::status(@_);
}

sub data {
    my $self = shift;
    return $self->SUPER::status unless @_;
    $self->SUPER::status(@_);
    $self->SUPER::data(@_);
}

sub body {
    my $self = shift;

    # setter
    return $self->SUPER::body(@_) if @_;

    # getter
    my $body = $self->SUPER::body;
    return $body if defined $body;

    # default
    my $code = $self->status;
    $self->data($code) if $code;

    $self->SUPER::body;
}

sub finalize {
    my $self = shift;
    $self->body; # touch
    $self->SUPER::finalize(@_);
}

1;
__END__

=head1 NAME

Plack::Response::Data::Status - Response Content Body of Status Message

=head1 SYNOPSIS

In your Plack app:

    use Plack::Response::Data::Status;

    sub psgi_handler {
        my $env  = shift;
        my $req  = Plack::Request->new($env);
     
        my $res  = Plack::Response::Data::Status->new(404);
        return $res->finalize;
    }

Response:

    HTTP/1.0 404 Not Found
    Content-Length: 11
    Content-Type: text/plain
    
    Not Found

=head1 DESCRIPTION

This writes the HTTP response status message at L<Plack::Response>'s response content body.
This would help you to respond an error code with its reason phrase
which is a short textual description defined in RFC 2616 and RFC 2518.
Response headers of C<Content-Type> and C<Content-Length> are also given.
L<HTTP::Status> module is required.

=head1 METHODS

This is a subclass of C<Plack::Response::Data> class.

=head2 code, data, status

The three methods effect the content body in the same manner.

    $res->code(404);
    $res->data(404);
    $res->status(404);

=head1 AUTHOR

Yusuke Kawasaki

=head1 SEE ALSO

L<Plack::Response>

L<Status>

=cut
