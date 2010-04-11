#!/usr/bin/perl

use warnings;
use strict;
use Test::More tests => 4;

use Archlinux::Messages;

my $TEN = q{1234567890};

sub output_of(&)
{
    my ($code_ref) = @_;

    open my $old_stdout, '>&STDOUT' or die "open: $!";
    my $out_buffer;
    close STDOUT;
    open STDOUT, '>', \$out_buffer or die "open: $!";

    $code_ref->();

    close STDOUT or die "close: $!";
    open STDOUT, '>&', $old_stdout or die "open: $!";

    return $out_buffer;
}

local $Archlinux::Messages::Mono = 1;

unlike( output_of { status( 'this should have no color' ) },
        qr/ \e [[] .*? m /xms,
        '$Archlinux::Messages::Mono should turn off colors' );

is output_of { status( ( $TEN x 7 ) . " $TEN" ) },
    '==> ' . ( $TEN x 7 ) . "\n    $TEN\n";

{
    $Archlinux::Messages::Columns = 9;

    is( output_of { status( "$TEN $TEN" ) },
        "==> 12345\n    67890\n    12345\n    67890\n",
        '$Archlinux::Messages::Columns can customize word wrapping' );
}

{
    $Archlinux::Messages::Columns = 0;

    is( output_of { msg( $TEN x 10 ) }, '    ' . $TEN x 10 . "\n",
        '$Archlinux::Messages::Columns can disable word wrapping' );
}
