use Test::More tests => 2;
use Debian::Parse::Uscan;
use Perl6::Slurp;
use Test::Deep;

my $parser = Debian::Parse::Uscan->new;
isa_ok($parser, 'Debian::Parse::Uscan');

my $output = slurp 't/data/uscan.txt';
cmp_deeply($parser->parse($output), {}, 'results');
