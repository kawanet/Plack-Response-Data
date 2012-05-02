use strict;
use Test::More;

eval {
    require JSON;
};

if ($@) {
    plan skip_all => 'JSON not installed';
} else {
    plan tests => 13;
}

use_ok 'Plack::Response::Data::JSON';

my $type = 'application/json';
my $data = { key => 'val', array => [1, 2, 3] };
my $test;

my $res = Plack::Response::Data::JSON->new(200);
ok(ref $res, 'new');

my $ret = $res->data($data);
is(ref $ret, ref $res, 'data');

my $final = $res->finalize;
ok($final, 'finalize');

is($res->headers->header('Content-Type'), $type, 'headers header content_type');
is($res->header('Content-Type'), $type, 'header content_type');
is($res->content_type, $type, 'content_type');

like($res->body, qr{"key":"val"}, 'body');
like($res->content, qr{"key":"val"}, 'content');

$test = JSON->new->decode($res->body);

is($test->{key}, 'val', 'body key');
is_deeply($test->{array}, [1, 2, 3], 'body array');

$test = $res->data;

is($test->{key}, 'val', 'data key');
is_deeply($test->{array}, [1, 2, 3], 'data array');
