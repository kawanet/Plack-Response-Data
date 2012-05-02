use ExtUtils::MakeMaker;

my $opt = {
    NAME                =>  'Plack::Response::Data',
    VERSION_FROM        =>  'lib/Plack/Response/Data.pm',
    ABSTRACT_FROM       =>  'lib/Plack/Response/Data.pm',
    CONFIGURE_REQUIRES  =>  {
        'ExtUtils::MakeMaker'   => '6.55',
    },
    BUILD_REQUIRES      =>  {
        'Test::More'            => '0.71',
        'Test::Pod'             => '1.41',
    },
    PREREQ_PM           =>  {
        'Carp'                  => '0',
        'JSON'                  => '2.00',
        'HTTP::Status'          => '6.00',
        'Plack'                 => '0.9948',
        'XML::TreePP'           => '0.41',
        'YAML::Any'             => '0.67',
    },
    AUTHOR              =>  'Yusuke Kawasaki',
    LICENSE             =>  'perl',
};

WriteMakefile( %$opt );
