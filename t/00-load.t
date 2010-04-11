#!perl -T

use Test::More tests => 1;

BEGIN {
    use_ok( 'Archlinux::Messages' ) || print "Bail out!
";
}

diag( "Testing Archlinux::Messages $Archlinux::Messages::VERSION, Perl $], $^X" );
