use Test::More tests => 8;
use Debian::Debhelper::Dh_components;

my $components = Debian::Debhelper::Dh_components->new(
    dir=>'t/data/test1',
    package=> 'Test1',
    build_stages=>['blah','bargle','boogie'],
    components=>['mungle1','comp2','mungle2'],
    rules_locations=>[
        't/data/test1/%',
        't/data/test1',
    ],
);
isa_ok($components, 'Debian::Debhelper::Dh_components');

my $bs = join '|', $components->build_stages;
is($bs, 'blah|bargle|boogie', 'build stages');
is($components->directory, 't/data/test1', 'directory');
is($components->package, 'Test1', 'package');

my @comps = sort $components->components;
is_deeply(\@comps, ['comp2'], 'component listing');

is($components->script('comp2','bargle'),"t/data/test1/bargle", 'bargle');
is($components->script('comp2','boogie'),"t/data/test1/comp2/boogie", 'boogie');
is($components->script('comp2','blah'),undef, 'blah');


