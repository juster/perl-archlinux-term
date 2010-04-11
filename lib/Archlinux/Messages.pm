package Archlinux::Messages;

use warnings;
use strict;

use Term::ANSIColor qw(color);
use Text::Wrap      qw(wrap);

our @ISA        = qw(Exporter);
our @EXPORT_ALL = qw(msg status substatus warning error);
our $VERSION    = '0.01';

our ($Columns, $Mono) = (78, undef);

sub _color_wrap
{
    my ($color, $prefix, @messages) = @_;

    # Wrap the uncolored first because ANSI color chars mess up wrap()
    # (it doesn't know the ANSI color codes are invisible)
    my $msg          = join q{}, @messages;
    $msg             =~ s/\s*\n\s*/ /g;

    $Text::Wrap::columns = $Columns;
    my $result       = wrap( $prefix, q{ } x length( $prefix ), $msg );
    my $prefix_match = quotemeta $prefix;

    return $result if ( $Mono );

    # Now colorize the prefix and stuff...
    $result =~ s{ \A $prefix_match } # Use \033[0;1m cuz Term::ANSIColor
                { color( "BOLD $color" ) . $prefix . "\033[0;1m" }exms;
    $result .= color( 'RESET' );     # ... doesnt have very bright white!

    return $result;
}

sub msg
{
    my $prefix   = q{ } x 4;
    my @messages = @_;
    chomp $messages[-1];

    print wrap( $prefix, $prefix, join q{}, @messages ), "\n";
}

sub status
{
    print _color_wrap( 'GREEN' => q{==> }, @_ ), "\n";
}

sub substatus
{
    print _color_wrap( 'BLUE' => q{  -> }, @_ ), "\n";
}

sub warning
{
    my @args = @_;
    chomp $args[-1];
    warn _color_wrap( 'YELLOW' => q{==> WARNING: }, @args ), "\n";
}

sub error
{
    my @args = @_;
    chomp $args[-1];
    die _color_wrap( 'RED' => q{==> ERROR: }, @args ), "\n";
}

1;

__END__

=head1 NAME

Archlinux::Messages - Display messages on the terminal Archlinux style!

=head1 VERSION

0.01

=head1 SYNOPSIS

  use Archlinux::Messages;

  status( 'This is a status message' );
  substatus( 'This is a substatus message' );
  warning( 'This is a warning message' );
  error( 'This is a fatal error message' ); # Also exits the program
  msg( 'This is just an indented message' );

Outputs:

  ==> This is a status message
    -> This is a substatus message
  ==> WARNING: This is a warning message
  ==> ERROR: This is a fatal error message
      This is just an indented message

=for html
 <div style="width: 500px; background:black; font-family:monospace;
             color:white; white-space:pre; border: solid white 1px;
             margin: 15px; "
 > EXAMPLE:
 <span style="color:green">==></span> This is a status message
 <span style="color:blue">  -></span> This is a substatus message
 <span style="color:yellow">==> WARNING:</span> This is a warning message
 <span style="color:red">==> ERROR:</span> This is a fatal error message
     This is just an indented message  
</div>

=head1 DESCRIPTION

Archlinux has a distinctive and simple style for displaying messages
on the terminal.  This style is used in the init scripts and Archlinux
programs like pacpan to give a cohesive look to Archlinux's terminal.
Now you can easily conform to this simple colorful style and fit right
in!

=head1 FUNCTIONS

All functions are exported by default.  This is a little sloppy, but
its easier when you're writing a quick script!  If you don't want to
pollute the namespace then just explicitly import nothing into your
namespace:

  use Archlinux::Messages qw();

Every function takes multiple arguments which are C<join>ed together,
word-wrapped and printed to the screen.  If a message goes past the
screen limit it is wordwrapped and indented past the prefix.

=head2 msg( text1 [ , text2, ... ] )

Prints a simple message.  There is no coloring it is merely
wordwrapped and indented by four spaces.

=head2 status( text1 [ , text2, ... ] )

Prints a status message.  These are basically like major headings in a
document.  The message is prefixed with a green arrow:

=head2 substatus( text1 [ , text2, ... ] )

Prints a sub-status message.  These are like minor headings in a
document.  The message is prefixed with a little blue arrow.

=head2 warning( text1 [ , text2, ... ] )

Prints a warning message.  These are non-fatal warning messages; the
program will keep running.  The message is prefixed with a yellow
arrow and capital WARNING.

=head2 error( text1 [ , text2, ... ] )

Prints a fatal error message B<AND DIES, EXITING>.  There is no line
number appended to the C<die> message. C<$@> or C<$EVAL_ERROR> is the
colorized output.  The message is prefixed with a red arrow and
capital ERROR.

The error can be caught with an enclosing C<eval> block.  If the error
isn't caught it is displayed on the screen and the program exits.

=head3 Example

  eval {
      if ( $stuff eq 'bad' ) {
          error( q{Stuff went bad!} )
      }
  };

  if ( $@ =~ /Stuff went bad!/ ) {
      warning( q{Stuff went bad, but it's okay now!} );
  }

=head1 AUTHOR

Justin Davis C<< < juster at cpan dot org > >>

=head1 LICENSE

Copyright 2010 Justin Davis, all rights reserved.

This program is free software; you can redistribute it and/or modify it
under the same terms as Perl itself.
