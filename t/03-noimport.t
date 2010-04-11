#!/usr/bin/perl

use warnings;
use strict;
use Test::More tests => 10;

use Archlinux::Messages qw();

eval { msg() };
like $@, qr/Undefined subroutine/;

eval { status() };
like $@, qr/Undefined subroutine/;

eval { substatus() };
like $@, qr/Undefined subroutine/;

eval { warning() };
like $@, qr/Undefined subroutine/;

eval { error() };
like $@, qr/Undefined subroutine/;

Archlinux::Messages::msg( 'This is only a test' );
ok !$@;

Archlinux::Messages::status( 'Do not attempt to adjust your TV set' );
ok !$@;

Archlinux::Messages::substatus( 'Emergency broadcast system' );
ok !$@;

{
    my $warned;
    local $SIG{__WARN__} = sub { $warned = 1; };
    Archlinux::Messages::warning( 'I warned you!' );
    ok $warned;
}

eval { Archlinux::Messages::error( 'Error!' ) };
like $@, qr/Error!/;
