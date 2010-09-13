use Test::More tests => 5;
use Debian::Debhelper::Dh_components;

my $components = Debian::Debhelper::Dh_components->new('t/data/test1', 'Test1');
isa_ok($components, 'Debian::Debhelper::Dh_components');

my $bs = join '|', $components->build_stages;
is($bs, 'copy|patch|config|build|test|install', 'build stages');
is($components->directory, 't/data/test1', 'directory');
is($components->package, 'Test1', 'package');

my @comps = sort $components->components;
is_deeply(\@comps, ['comp1', 'comp2', 'comp3'], 'component listing');

