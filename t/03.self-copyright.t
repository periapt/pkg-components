use Test::More tests => 14;

use Debian::Copyright;

my $copyright = Debian::Copyright->new;
isa_ok($copyright, 'Debian::Copyright');
$copyright->read('debian/copyright');
like($copyright->header, qr{\AFormat-Specification:\s}xms, 'Header stanza');
is($copyright->files->Length, 2, 'files length');
is($copyright->files->Keys(0), '*', 'key files(0)');
is($copyright->files->Values(0)->Files, '*', 'files(0)->Files');
is($copyright->files->Values(0)->Copyright, '2010-2011, Nicholas Bamber <nicholas@periapt.co.uk>', 'files(0)->Copyright');
is($copyright->files->Values(0)->License, 'Artistic or GPL-2+', 'files(0)->License');
is($copyright->files->Keys(1), 'lib/Debian/Copyright*', 'key files(1)');
is($copyright->files->Values(1)->Files, 'lib/Debian/Copyright*', 'files(1)->Files');
is($copyright->files->Values(1)->Copyright."\n", <<'EOF',

 2011, Nicholas Bamber <nicholas@periapt.co.uk>
 2009, Damyan Ivanov <dmn@debian.org> [Portions]
EOF
 'files(1)->Copyright');
is($copyright->files->Values(1)->License, 'GPL-2+', 'files(1)->License');
is($copyright->licenses->Length, 2, 'licenses length');
is($copyright->licenses->Keys(0), 'Artistic', 'key licenses(0)');
like($copyright->licenses->Values(0)->License, qr/\AArtistic\s+This\sprogram/xms, 'licenses(0)->Files');

