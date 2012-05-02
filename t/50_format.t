use strict;
use Test::More tests => 16;

use_ok 'Plack::Response::Data';

my $res = Plack::Response::Data->new;
ok(ref $res, 'new');

is($res->format || '', '', 'default format');

$res->format('JSON');
is(ref $res, 'Plack::Response::Data::JSON', 'JSON ref');
is($res->format, 'JSON', 'JSON format');

$res->format('XML');
is(ref $res, 'Plack::Response::Data::XML', 'XML ref');
is($res->format, 'XML', 'XML format');

$res->format('YAML');
is(ref $res, 'Plack::Response::Data::YAML', 'YAML ref');
is($res->format, 'YAML', 'YAMl format');

$res->format('Status');
is(ref $res, 'Plack::Response::Data::Status', 'Status ref');
is($res->format, 'Status', 'Status format');

$res->format('JSON');
is(ref $res, 'Plack::Response::Data::JSON', 'JSON ref (reload)');
is($res->format, 'JSON', 'JSON format (reload)');

$res->format('JSON');
is(ref $res, 'Plack::Response::Data::JSON', 'JSON ref (same)');
is($res->format, 'JSON', 'JSON format (same)');

eval {
    $res->format('NOT FOUND');
};
ok($@, 'NOT FOUND');
