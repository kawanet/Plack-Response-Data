package Plack::Response::Data::JSON;
use strict;
use warnings;
use base 'Plack::Response::Data';

our $VERSION = '0.01';
$VERSION = eval $VERSION;

use Carp ();
use JSON ();

sub mime_type {
    'application/json';
}

sub handler {
    my $handler = JSON->new;
    $handler->utf8(1);
    $handler;
}

sub encode {
    my $self = shift;
    my $data = shift;
    my $handler = $self->handler or Carp::croak "JSON handler was not available";
    my $body;
    eval {
        $body = $handler->encode($data);
    };
    $body;
}

sub decode {
    my $self = shift;
    my $body = shift;
    my $handler = $self->handler or Carp::croak "JSON handler was not available";
    my $data;
    eval {
        $data = $handler->decode($body);
    };
    $data;
}

1;
__END__

=head1 NAME

Plack::Response::Data::JSON - Response Content Body Encoder/Decoder for JSON

=head1 SYNOPSIS

In your Plack app:

    use Plack::Response::Data::JSON;

    sub psgi_handler {
        my $env  = shift;
        my $req  = Plack::Request->new($env);
    
        my $data = { foo => 'bar', qux => [1, 2, 3] };
        my $res  = Plack::Response::Data::JSON->new(200)->data($data);
        return $res->finalize;
    }

Response:

    HTTP/1.0 200 OK
    Content-Length: 13
    Content-Type: application/json
    
    {"foo":"bar","qux":[1,2,3]}

=head1 DESCRIPTION

This uses L<Plack::Response>'s response content body as a data container
to respond a data encoded in JSON.
This would help you to build an Web API server application in a short code.
L<JSON> module is required.

=head1 METHODS

This is a subclass of C<Plack::Response::Data> class.

=head2 data

This writes a data object into the response content body as JSON.

    $data = {foo => 'bar'};     # a hashref
    $res->data($data);
    $body = $res->body;         # returns a JSON encoded string: '{"foo":"bar"}'

Without arguments given, this parses the current resopnse content body
as a data object vice versa.

    $body = '{"foo":"bar"}';    # a JSON encoded string
    $res->body($body);
    $data = $res->data;         # returns a hashref decoded: {foo => 'bar'}

=head2 encode, decode

This also provides the bidirectional encoder and decoder methods as below.

    $text = Plack::Response::Data::JSON->encode($data); # object to string
    $data = Plack::Response::Data::JSON->decode($text); # string to object

=head1 SAMPLE ECHO APP

The following PSGI app does just echo a JSON request to a JSON response.
You would need error handlings and security considerations for production
use however.

    use Plack::Request;
    use Plack::Response::Data::JSON;
    
    sub {
        my $env  = shift;
        my $req  = Plack::Request->new($env);
        my $body = $req->content;
        my $data = Plack::Response::Data::JSON->decode($body);
        # do something
        my $res  = Plack::Response::Data::JSON->new(200);
        $res->data($data);
        $res->finalize;
    }

=head1 AUTHOR

Yusuke Kawasaki

=head1 SEE ALSO

L<Plack::Response>

L<JSON>

=cut
