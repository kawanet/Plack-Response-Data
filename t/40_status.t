use strict;
use Test::More;

plan tests => 38;

use_ok 'Plack::Response::Data::Status';

my $type = 'text/plain';
my $res;
my $test;

## 200 OK

$res = Plack::Response::Data::Status->new(200);
ok($res, '200 new');

like($res->body, qr{OK}, '200 body');
like($res->content, qr{OK}, '200 content');

is($res->code, 200, '200 code');
is($res->status, 200, '200 status');
is($res->data, 200, '200 data');

is($res->headers->header('Content-Type'), $type, '200 headers header content_type');
is($res->header('Content-Type'), $type, '200 header content_type');
is($res->content_type, $type, '200 content_type');

## 304 Not Modified

$res = Plack::Response::Data::Status->new;
ok($res, '304 new');
my $ret = $res->data(304);
is(ref $ret, ref $res, '304 data');

like($res->body, qr{Not Modified}i, '304 body');
like($res->content, qr{Not Modified}i, '304 content');

is($res->code, 304, '304 code');
is($res->status, 304, '304 status');
is($res->data, 304, '304 data');

is($res->headers->header('Content-Type'), $type, '304 headers header content_type');
is($res->header('Content-Type'), $type, '304 header content_type');
is($res->content_type, $type, '304 content_type');

## 404 Not Found

$res = Plack::Response::Data::Status->new;
ok($res, '404 new');
$res->code(404);

like($res->body, qr{Not Found}i, '404 body');
like($res->content, qr{Not Found}i, '404 content');

is($res->code, 404, '404 code');
is($res->status, 404, '404 status');
is($res->data, 404, '404 data');

is($res->headers->header('Content-Type'), $type, '404 headers header content_type');
is($res->header('Content-Type'), $type, '404 header content_type');
is($res->content_type, $type, '404 content_type');

## 501 Not Implemented

$res = Plack::Response::Data::Status->new;
ok($res, '501 new');
$res->status(501);

like($res->body, qr{Not Implemented}i, '501 body');
like($res->content, qr{Not Implemented}i, '501 content');

is($res->code, 501, '501 code');
is($res->status, 501, '501 status');
is($res->data, 501, '501 data');

is($res->headers->header('Content-Type'), $type, '501 headers header content_type');
is($res->header('Content-Type'), $type, '501 header content_type');
is($res->content_type, $type, '501 content_type');
