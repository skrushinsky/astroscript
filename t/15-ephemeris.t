#!/usr/bin/env perl -w

use strict;
use warnings;

our $VERSION = '1.00';

use FindBin qw/$Bin/;
use lib "$Bin/../lib";
use Test::More;
use Test::Number::Delta within => 1e-5;

BEGIN {
	use_ok( 'AstroScript::Ephemeris', qw/:all/ );
    use_ok( 'AstroScript::Ephemeris::Point', qw/:ids/ );
    use_ok( 'AstroScript::Ephemeris::Planet', qw/:ids/ );
}

my $jd;
my $data;
my @ids;

BEGIN {
    my $path = "$Bin/19650201.txt";
    open(my $TEST, '<', $path) or die "Could not open $path: $!\n";

    while(<$TEST>) {
        chomp;
        my @flds = split /\s+/;
        next unless @flds;

        if ($flds[0] eq 'JD') {
            $jd = $flds[1]
        }
        else {
            push @ids, $flds[0];
            $data->{$flds[0]} = [ @flds[1..3] ]
        }
    }
    close $TEST;
}

subtest 'Planets' => sub {

    plan tests => (scalar @ids) * 3;
    my $t  = ($jd - 2451545) / 36525;
    my $iter = planets($t, \@ids);
    while ( my $res = $iter->() ) {
        my ($id, $pos) = @$res;
        my ($x0, $y0, $z0) = @{ $data->{$id} };
        my ($x1, $y1, $z1) = ($pos->{x}, $pos->{y}, $pos->{z});

        delta_ok($x0, $x1, "$id X") or diag("Expected: $x0, got: $x1");
        delta_ok($y0, $y1, "$id Y") or diag("Expected: $y0, got: $y1");
        delta_ok($z0, $z1, "$id Z") or diag("Expected: $z0, got: $z1");
    }
};

subtest 'Lunar Node' => sub {
    my $t  = ($jd - 2451545) / 36525;
    my $coo;
    ($_, $coo) = @{ planets($t, [$LN])->() };
    delta_ok(81.683527, $coo->{x}, 'True Node') or diag("Expected: 81.683527, got: $coo->{x}");
    ($_, $coo) = @{ planets($t, [$LN], true_node => 0)->() };
    delta_ok(80.311735, $coo->{x}, 'Mean Node') or diag("Expected: 80.311735, got: $coo->{x}");
};

subtest 'Pluto' => sub {
    plan tests => 4;

    is(planets(-1.10000002101935, [$PL])->(), undef, '1889-12-30 23:59')
        or diag('Expected undefined result for years < 1890');

    is(planets(1.00000001901285, [$PL])->(), undef, '2100-01-01 12:01')
        or diag('Expected undefined result for years > 2099');

    ok(planets(-1.09999998299365, [$PL])->(), '1889-12-31 00:01')
        or diag('Expected defined result for years > 1889');

    ok(planets(0.999999980987148, [$PL])->(), '2100-01-01 11:59')
        or diag('Expected defined result for years < 2101');
};

done_testing();
