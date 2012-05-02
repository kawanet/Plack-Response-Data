use strict;
use Test::More;

eval {
    require YAML::Any;
};

if ($@) {
    plan skip_all => 'YAML::Any not installed';
} else {
    plan tests => 15;
}

use_ok 'Plack::Response::Data::YAML';

my $type = 'text/yaml';
my $data = { key => 'val', array => [1, 2, 3] };
my $test;

my $res = Plack::Response::Data::YAML->new(200);
ok(ref $res, 'new');

my $ret = $res->data($data);
is(ref $ret, ref $res, 'data');

my $final = $res->finalize;
ok($final, 'finalize');

is($res->headers->header('Content-Type'), $type, 'headers header content_type');
is($res->header('Content-Type'), $type, 'header content_type');
is($res->content_type, $type, 'content_type');

like($res->body, qr{key:\s*val}, 'body');
like($res->content, qr{key:\s*val}, 'content');

$test = YAML::Any::Load($res->body);
ok(ref $test, 'Load');

is($test->{key}, 'val', 'body key');
is_deeply($test->{array}, [1, 2, 3], 'body array');

$test = $res->data;
ok(ref $test, 'data');

is($test->{key}, 'val', 'data key');
is_deeply($test->{array}, [1, 2, 3], 'data array');
