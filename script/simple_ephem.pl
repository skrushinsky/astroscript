#!/usr/bin/env perl
use 5.22.0;
use strict;
use warnings;
use FindBin qw/$Bin/;
use lib ("$Bin/../lib");

use AstroScript::Ephemeris::Planet qw/@PLANETS/;
use AstroScript::Ephemeris qw/find_positions/;

my $jd = 2458630.5; # Standard Julian date for May 27, 2019, 00:00 UTC.
my $t  = ($jd - 2451545) / 36525; # Convert Julian date to centuries since epoch 2000.0

find_positions($t, \@PLANETS, sub {
    my ($id, %pos) = @_;
    print "$id X: $pos{x}, Y: $pos{y}, Z: $pos{z}\n";
})
