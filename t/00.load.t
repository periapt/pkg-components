use Test::More tests => 6;

BEGIN {
use_ok( 'Debian::Debhelper::Dh_components' );
use_ok( 'Debian::Copyright' );
use_ok( 'Debian::Copyright::Stanza' );
use_ok( 'Debian::Copyright::Stanza::Header' );
use_ok( 'Debian::Copyright::Stanza::Files' );
use_ok( 'Debian::Copyright::Stanza::License' );
}

diag( "Testing Debian::Debhelper::Dh_components $Debian::Debhelper::Dh_components::VERSION" );
