use Test::More tests => 2;

BEGIN {
use_ok( 'Debian::Debhelper::Dh_components' );
use_ok( 'Debian::Parse::Uscan' );
}

diag( "Testing Debian::Debhelper::Dh_components $Debian::Debhelper::Dh_components::VERSION" );
