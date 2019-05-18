#!/usr/bin/env perl -w

use strict;
use FindBin qw/$Bin/;
use lib ("$Bin/../lib");
use Test::More;
use Test::Number::Delta within => 1e-5;

use AstroScript::Houses qw/cusps in_house opp :systems/;

subtest 'House Systems' => sub {
    my %cases = (
        $PLACIDUS => [
            110.142255, 123.854974, 140.662076, 164.322565, 201.302364, 251.588773,
            290.142255, 303.854974, 320.662076, 344.322565, 21.302364,  71.588773,
        ],
        $KOCH => [
            110.142255, 128.885000, 146.836593, 164.322565, 233.053648, 268.038983,
            290.142255, 308.885000, 326.836593, 344.322565, 53.0536480, 88.0389830,
        ],
        $REGIOMONTANUS => [
            110.142255, 127.971515, 143.525300, 164.322565, 204.378187, 259.163656,
            290.142255, 307.971515, 323.525300, 344.322565, 24.378187, 79.163656
        ],
        $CAMPANUS => [
            110.142255, 135.976970, 150.671701, 164.322565, 184.826810, 232.020322,
            290.142255, 315.976970, 330.671701, 344.322565, 4.826810, 52.020322
        ],
        $MORINUS => [
            74.322564, 106.880767, 138.018820, 166.705729, 194.331070, 223.095056,
            254.322564, 286.880767, 318.018820, 346.705729, 14.331070, 43.095056
        ],
        $EQUAL_ASC => [
            110.142255, 140.142255, 170.142255, 200.142255, 230.142255, 260.142255,
            290.142255, 320.142255, 350.142255, 20.142255,  50.142255,  80.142255,
        ],
        $WHOLESIGN => [ 90, 120, 150, 180, 210, 240, 270, 300, 330, 0, 30, 60 ]
    );

    plan tests => (scalar (keys %cases)) * 12;

    my %args = (
        as => 110.142255,
        mc => 344.322565,
        rm => 345.559001,
        ob => 23.430827,
        la => 55.75,
    );

    for my $sys (keys %cases) {
        my $got = cusps($sys, %args);
        my $exp = $cases{$sys};
        for ( 0 .. 11 ) {
            delta_ok ($exp->[$_], $got->[$_], sprintf('%-2d %-13s', $_+1, $sys))
                or diag "Expected: $exp->[$_], got: $got->[$_]";
        }

    }
};

subtest 'In house' => sub {
    plan tests => 10;
    my $cusps = [
        110.142255, 123.854974, 140.662076, 164.322565, 201.302364, 251.588773,
        290.142255, 303.854974, 320.662076, 344.322565, 21.302364,  71.588773,
    ];
    cmp_ok(7, '==', in_house(310.21, $cusps), 'Moon in VIII');
    cmp_ok(7, '==', in_house(312.43, $cusps), 'Sun in VIII');
    cmp_ok(6, '==', in_house(297.08, $cusps), 'Mercury in VII');
    cmp_ok(6, '==', in_house(295.21, $cusps), 'Venus in VII');
    cmp_ok(3, '==', in_house(177.97, $cusps), 'Mars in IV');
    cmp_ok(10, '==', in_house(46.93, $cusps), 'Jupiter in XI');
    cmp_ok(8, '==', in_house(334.60, $cusps), 'Saturn in IX');
    cmp_ok(2, '==', in_house(164.03, $cusps), 'Uranus in III');
    cmp_ok(4, '==', in_house(229.92, $cusps), 'Neptune in V');
    cmp_ok(3, '==', in_house(165.83, $cusps), 'Pluto in IV');
};


done_testing();
