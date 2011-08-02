use Test::More tests => 5;

use Debian::Copyright;

my $copyright = Debian::Copyright->new;
isa_ok($copyright, 'Debian::Copyright');
$copyright->read('debian/copyright');
like($copyright->header, qr{\AFormat-Specification:\s}xms, 'Header stanza');
is($copyright->files->Values(0)->Files, '*', 'files(0)->Files');
is($copyright->files->Values(0)->Copyright, '2010-2011, Nicholas Bamber <nicholas@periapt.co.uk>', 'files(0)->Copyright');
is($copyright->files->Values(0)->License, 'Artistic or GPL-2+', 'files(0)->License');

