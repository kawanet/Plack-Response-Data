package Plack::Response::Data::YAML;
use strict;
use warnings;
use base 'Plack::Response::Data';

our $VERSION = '0.01';
$VERSION = eval $VERSION;

use Carp ();
use YAML::Any;

sub mime_type {
    'text/yaml';
}

sub encode {
    my $self = shift;
    my $data = shift;
    my $body = Dump($data);
    $body;
}

sub decode {
    my $self = shift;
    my $body = shift;
    my $data = Load($body);
    $data;
}

1;
__END__

=head1 NAME

Plack::Response::Data::YAML - Response Content Body Encoder/Decoder for YAML

=head1 SYNOPSIS

In your Plack app:

    use Plack::Response::Data::YAML;

    sub psgi_handler {
        my $env  = shift;
        my $req  = Plack::Request->new($env);

        my $data = { foo => 'bar', qux => [1, 2, 3] };
        my $res  = Plack::Response::Data::YAML->new(200)->data($data);
        return $res->finalize;
    }

Response:

    HTTP/1.0 200 OK
    Content-Length: 38
    Content-Type: text/yaml
    
    --- 
    foo: bar
    qux: 
      - 1
      - 2
      - 3

=head1 DESCRIPTION

This uses L<Plack::Response>'s response content body as a data container
to respond a data encoded in YAML.
L<YAML::Any> module is required.

=head1 METHODS

This is a subclass of C<Plack::Response::Data> class.

=head2 data

This writes a data object into the response content body as YAML.

    $data = {foo => 'bar'};     # a hashref
    $res->data($data);
    $body = $res->body;         # returns a YAML encoded string

Without arguments given, this parses the current resopnse content body
as a data object vice versa.

    $body = '{"foo":"bar"}';    # a YAML encoded string
    $res->body($body);
    $data = $res->data;         # returns a hashref decoded

=head2 encode, decode

This also provides the bidirectional encoder and decoder methods as below.

    $text = Plack::Response::Data::YAML->encode($data); # object to string
    $data = Plack::Response::Data::YAML->decode($text); # string to object

=head1 AUTHOR

Yusuke Kawasaki

=head1 SEE ALSO

L<Plack::Response>

L<YAML::Any>

=cut
