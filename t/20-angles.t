use strict;
use warnings;

our $VERSION = '1.00';

use FindBin qw/$Bin/;
use lib "$Bin/../lib";
use Test::More;
use Test::Number::Delta within => 1e-4;

BEGIN {
	use_ok( 'AstroScript::Angles', qw/:all/ );
}

subtest 'Sensitive Points' => sub {
    plan tests => 4;

    my $theta = 55.75;
    my $eps   = 23.4442556;
    my $ramc  = 345.5553;
    my $asc   = 110.1572;
    my $mc    = 344.3172;
    my $vx    = 242.7036;
    my $ep    = 76.7036;

    my $got = midheaven($ramc, $eps);
    delta_within($mc, 1e-3, $got, 'Midheaven') or diag("Expected $mc, got: $got");

    $got = ascendant($ramc, $eps, $theta);
    delta_ok($asc, $got, 'Ascendant') or diag("Expected $asc, got: $got");

    $got = vertex($ramc, $eps, $theta);
    delta_ok($vx, $got, 'Vertex') or diag("Expected $vx, got: $got");

    $got = eastpoint($ramc, $eps);
    delta_ok($ep, $got, 'East Point') or diag("Expected $ep, got: $got");
};

subtest 'Extreme Latitudes' => sub {
    my $ramc = 45.0;
    my $mc = 47.47;
    my $asc = 144.92;
    my $eps = 23.4523;
    my @lats = (71.5, 85, -71.5);

    plan tests => scalar @lats + 2;

    for (@lats) {
        ok(is_highlat($_, $eps), "Extreme latitude $_") or diag("$_ should be qualified as extreme");
    }

    ok(!is_highlat(55.75, $eps), "Latitude 55.75") or diag("55.75 should not be qualified as extreme");
    ok(!is_highlat(-55.75, $eps), "Latitude -55.75") or diag("-55.75 should not be qualified as extreme");
};



done_testing();
