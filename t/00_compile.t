use strict;
use Test::More tests => 5;

BEGIN {
    use_ok 'Plack::Response::Data';
    use_ok 'Plack::Response::Data::JSON';
    use_ok 'Plack::Response::Data::Status';
    use_ok 'Plack::Response::Data::XML';
    use_ok 'Plack::Response::Data::YAML';
}
