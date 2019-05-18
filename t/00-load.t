#!/usr/bin/env perl -w

use 5.22.0;
use strict;
use warnings;
use Test::More;

use FindBin qw/$Bin/;
use lib "$Bin/../lib";

plan tests => 1;

BEGIN {
    use_ok( 'AstroScript::Ephemeris' ) || print "Bail out!\n";
}

diag( "Testing AstroScript::Ephemeris $AstroScript::Ephemeris::VERSION, Perl $], $^X" );
