package Plack::Response::Data;
use strict;
use warnings;
use base 'Plack::Response';

our $VERSION = '0.01';
$VERSION = eval $VERSION;

use Carp ();
use Plack::Util;

sub mime_type {
    Carp::croak "Not implemented";
}

sub encode {
    Carp::croak "Not implemented";
}

sub decode {
    Carp::croak "Not implemented";
}

sub data {
    my $self = shift;

    if (@_) {
        my $data = shift;
        my $body = $self->encode($data);
        $self->body($body);
        my $type = $self->mime_type;
        $self->content_type($type) if $type;
        $self->content_length(length($body));
        return $self; # chained
    }

    my $body = $self->_body;
    return unless defined $body;

    if (ref $body ne 'ARRAY') {
        $body = join("" => @$body);
    } elsif (ref $body) {
        my @buf;
        Plack::Util::foreach($body, sub { push(@buf, $_[0]) });
        $self->body(\@buf);
        $body = join("" => @buf);
    }
    $self->decode($body);
}

sub format {
    my $self = shift;
    $self = $self->new unless ref $self;

    my $current = ref $self;
    my $base    = __PACKAGE__;
    my $format;

    if (@_) {
        $format = shift or Carp::croak "Invalid container format";
        my $class  = $base.'::'.$format;
        if ($class ne $current) {
            my $file = $class;
            $file =~ s!::!/!g;
            $file .= '.pm';
            $class = Plack::Util::load_class($format, $base) unless $INC{$file};
            bless $self, $class;
        }
        $self->body(undef); # empty
        return $self; # chained
    }

    $format = ($current =~ m/^\Q$base\E::(.*)$/)[0];
    $format;
}

sub _get_version {
    my $class = shift;
    my $name = $class."::VERSION";
    no strict 'refs';
    $$name;
}

1;
__END__

=head1 NAME

Plack::Response::Data - Response Content Body Encoder for JSON, XML, YAML, etc.

=head1 SYNOPSIS

    use Plack::Response::Data;

    sub psgi_handler {
        my $env  = shift;
        my $req  = Plack::Request->new($env);
    
        my $data = { key => 'value', array => [1, 2, 3] };
        my $res  = Plack::Response::Data->new(200)->format('JSON')->data($data);
        return $res->finalize;
    }

=head1 DESCRIPTION

This uses L<Plack::Response>'s response content body as a data container
to respond a data encoded in JSON, XML, YAML format, etc.
This would help you to build an Web API server application in a short code.

=head1 METHODS

This is a subclass of C<Plack::Response> class.
This provides the following additional methods
as well as other methods inherited since C<Plack::Response>.

=head2 format

This specifies a data container format.
Any formats found at C<Plack::Response::Data::*> modules are supported.

    $res->format('JSON');       # uses Plack::Response::Data::JSON
    $res->format('XML');        # uses Plack::Response::Data::XML
    $res->format('YAML');       # uses Plack::Response::Data::YAML

Without arguments given, this returns the current format.

    $format = $res->format;     # returns 'JSON' etc.

=head2 data

This writes a data object into response content body.

    $data = {key => 'val'};     # a hashref
    $res->data($data);
    $body = $res->body;         # returns a JSON encoded string: '{"key":"val"}'

Without arguments given, this parses the current resopnse content body
as a data object vice versa.

    $body = '{"key":"val"}';    # a JSON encoded string
    $res->body($body);
    $data = $res->data;         # returns a hashref decoded: {key => 'val'}

=head1 AUTHOR

Yusuke Kawasaki

=head1 SEE ALSO

L<Plack::Response>

L<Plack::Response::Data::JSON>

L<Plack::Response::Data::XML>

L<Plack::Response::Data::YAML>

=cut
