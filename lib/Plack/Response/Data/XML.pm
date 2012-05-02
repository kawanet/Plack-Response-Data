package Plack::Response::Data::XML;
use strict;
use warnings;
use base 'Plack::Response::Data';

our $VERSION = '0.01';
$VERSION = eval $VERSION;

use Carp ();
use XML::TreePP;

sub mime_type {
    'application/xml';
}

sub handler {
    my $handler = XML::TreePP->new;
    $handler;
}

sub encode {
    my $self = shift;
    my $data = shift;
    my $handler = $self->handler or Carp::croak "XML handler was not available";
    my $body = $handler->write($data);
    utf8::encode($body);
    $body;
}

sub decode {
    my $self = shift;
    my $body = shift;
    my $handler = $self->handler or Carp::croak "XML handler was not available";
    utf8::decode($body);
    my $data = $handler->parse($body);
    $data;
}


1;
__END__

=head1 NAME

Plack::Response::Data::XML - Response Content Body Encoder/Decoder for XML

=head1 SYNOPSIS

In your Plack app:

    use Plack::Response::Data::XML;

    sub psgi_handler {
        my $env  = shift;
        my $req  = Plack::Request->new($env);
    
        my $data = { foo => 'bar', qux => [1, 2, 3] };
        my $res  = Plack::Response::Data::XML->new(200)->data($data);
        return $res->finalize;
    }

Response:

    HTTP/1.0 200 OK
    Content-Length: 107
    Content-Type: application/xml
    
    <?xml version="1.0" encoding="UTF-8" ?>
    <xml>
    <foo>bar</foo>
    <qux>1</qux>
    <qux>2</qux>
    <qux>3</qux>
    </xml>

=head1 DESCRIPTION

This uses L<Plack::Response>'s response content body as a data container
to respond a data encoded in XML format.
This would help you to build an Web API server application in a short code.
L<XML::TreePP> module is required.

=head1 METHODS

This is a subclass of C<Plack::Response::Data> class.

=head2 data

This writes a data object into the response content body as XML.

    $data = {foo => 'bar'};     # a hashref
    $res->data($data);
    $body = $res->body;         # returns an XML encoded string: '{"foo":"bar"}'

Without arguments given, this parses the current resopnse content body
as a data object vice versa.

    $body = '{"foo":"bar"}';    # an XML encoded string
    $res->body($body);
    $data = $res->data;         # returns a hashref decoded: {foo => 'bar'}

=head2 encode, decode

This also provides the bidirectional encoder and decoder methods as below.

    $text = Plack::Response::Data::XML->encode($data); # object to string
    $data = Plack::Response::Data::XML->decode($text); # string to object

=head1 SAMPLE ECHO APP

The following PSGI app does just echo an XML request to an XML response.
You would need error handlings and security considerations for production
use however.

    use Plack::Request;
    use Plack::Response::Data::XML;
    
    sub {
        my $env  = shift;
        my $req  = Plack::Request->new($env);
        my $body = $req->content;
        my $data = Plack::Response::Data::XML->decode($body);
        # do something
        my $res  = Plack::Response::Data::XML->new(200);
        $res->data($data);
        $res->finalize;
    }

=head1 AUTHOR

Yusuke Kawasaki

=head1 SEE ALSO

L<Plack::Response>

L<XML::TreePP>

=cut
