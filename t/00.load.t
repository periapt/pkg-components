use Test::More tests => 7;

BEGIN {
use_ok( 'Debian::Debhelper::Dh_components' );
use_ok( 'Debian::Copyright' );
use_ok( 'Debian::Copyright::Stanza' );
use_ok( 'Debian::Copyright::Stanza::Header' );
use_ok( 'Debian::Copyright::Stanza::Files' );
use_ok( 'Debian::Copyright::Stanza::License' );
use_ok( 'Debian::Copyright::Stanza::OrSeparated' );
}

diag( "Testing Debian::Debhelper::Dh_components $Debian::Debhelper::Dh_components::VERSION" );
