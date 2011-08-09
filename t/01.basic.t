use Test::More tests => 23;
use Debian::Debhelper::Dh_components;
use Readonly;

Readonly my $COPYRIGHT_OUT => 't/data/copyright/out1';

my $components = Debian::Debhelper::Dh_components->new(
    dir=>'t/data/test1',
    package=> 'Test1',
    rules_locations=>[
        't/data/test1/%',
        't/data/test1',
        'build_stages',
    ],
);
isa_ok($components, 'Debian::Debhelper::Dh_components');

my $bs = join '|', $components->build_stages;
is($bs, 'copy|patch|config|build|test|install', 'build stages');
is($components->directory, 't/data/test1', 'directory');
is($components->package, 'Test1', 'package');

my @comps = sort $components->components;
is_deeply(\@comps, ['comp1', 'comp2', 'comp3'], 'component listing');

foreach my $bs ($components->build_stages) {
    is($components->script('comp1',$bs),"build_stages/$bs", $bs);
}

foreach my $bs ($components->build_stages) {
    is($components->script('comp2',$bs),"t/data/test1/comp2/$bs", $bs);
}

foreach my $bs ($components->build_stages) {
    is($components->script('comp3',$bs),
        $bs eq 'patch'
            ? "t/data/test1/comp3/$bs"
            : "build_stages/$bs", $bs);
}

$components->build_copyright($COPYRIGHT_OUT);
unlink $COPYRIGHT_OUT;
