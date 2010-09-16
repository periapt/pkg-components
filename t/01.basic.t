use Test::More tests => 6;
use Debian::Debhelper::Dh_components;

my $components = Debian::Debhelper::Dh_components->new(
    dir=>'t/data/test1',
    package=> 'Test1',
    rules_locations=>[
        't/data/test1/%',
        't/data/test1',
        'etc/dh_components',
    ],
);
isa_ok($components, 'Debian::Debhelper::Dh_components');

my $bs = join '|', $components->build_stages;
is($bs, 'copy|patch|config|build|test|install', 'build stages');
is($components->directory, 't/data/test1', 'directory');
is($components->package, 'Test1', 'package');

my @comps = sort $components->components;
is_deeply(\@comps, ['comp1', 'comp2', 'comp3'], 'component listing');

is($components->script('comp1','copy'),'etc/dh_components/copy', 'copy');

