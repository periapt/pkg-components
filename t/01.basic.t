use Test::More tests => 26;
use Debian::Debhelper::Dh_components;
use Readonly;
use Perl6::Slurp;
use Test::LongString;
use Test::NoWarnings;
use Test::Deep;

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
my $expected = slurp 't/data/copyright/expected1';
my $out = slurp $COPYRIGHT_OUT;
is_string($out, $expected, "file contents");

cmp_deeply($components->substvars(),
    [
        {deppackage=>'dep1',component=>'comp1',substvar=>'Depends',rel=>undef,ver=>undef},
        {deppackage=>'dep2',component=>'comp1',substvar=>'Depends',rel=>'>=',ver=>'0.67'},
        {deppackage=>'rec1',component=>'comp1',substvar=>'Recommends',rel=>undef,ver=>undef},
        {deppackage=>'rec2',component=>'comp1',substvar=>'Recommends',rel=>'=',ver=>'0.650'},
        {deppackage=>'sug1',component=>'comp1',substvar=>'Suggests',rel=>'<=',ver=>'0.8'},
        {deppackage=>'enh1',component=>'comp1',substvar=>'Enhances',rel=>undef,ver=>undef},
        {deppackage=>'repl1',component=>'comp1',substvar=>'Replaces',rel=>undef,ver=>undef},
        {deppackage=>'pre1',component=>'comp1',substvar=>'Pre-Depends',rel=>undef,ver=>undef},
        {deppackage=>'confl1',component=>'comp1',substvar=>'Conflicts',rel=>undef,ver=>undef},
        {deppackage=>'break1',component=>'comp1',substvar=>'Breaks',rel=>undef,ver=>undef},
    ], 'substvars');

unlink $COPYRIGHT_OUT;
