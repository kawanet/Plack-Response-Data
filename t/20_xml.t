use strict;
use Test::More;

eval {
    require XML::TreePP;
};

if ($@) {
    plan skip_all => 'XML::TreePP not installed';
} else {
    plan tests => 15;
}

use_ok 'Plack::Response::Data::XML';

my $type = 'application/xml';
my $data = { root => { key => 'val', array => [1, 2, 3] }};
my $test;

my $res = Plack::Response::Data::XML->new(200);
ok(ref $res, 'new');

my $ret = $res->data($data);
is(ref $ret, ref $res, 'data');

my $final = $res->finalize;
ok($final, 'finalize');

is($res->headers->header('Content-Type'), $type, 'headers header content_type');
is($res->header('Content-Type'), $type, 'header content_type');
is($res->content_type, $type, 'content_type');

like($res->body, qr{<key>val</key>}, 'body');
like($res->content, qr{<key>val</key>}, 'content');

$test = XML::TreePP->new->parse($res->body);
ok(ref $test, 'decode');

$test = $test->{root};
is($test->{key}, 'val', 'body key');
is_deeply($test->{array}, [1, 2, 3], 'body array');

$test = $res->data;
ok(ref $test, 'data');

$test = $test->{root};
is($test->{key}, 'val', 'data key');
is_deeply($test->{array}, [1, 2, 3], 'data array');
