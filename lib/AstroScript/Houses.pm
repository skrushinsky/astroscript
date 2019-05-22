package AstroScript::Houses;
use strict;
use Readonly;
use Exporter qw/import/;

my @SYSTEMS = qw/
    $PLACIDUS $KOCH $ARIES $REGIOMONTANUS $MORINUS $CAMPANUS
    $WHOLESIGN $EQUAL_ASC
/;

our %EXPORT_TAGS = (
    all => [ @SYSTEMS, qw/cusps in_house opp/],
    systems => \@SYSTEMS,
);

our @EXPORT_OK = ( @{ $EXPORT_TAGS{'all'} } );

our $VERSION = '1.00';

use POSIX qw /tan acos asin/;
use Math::Trig qw/deg2rad rad2deg/;
use AstroScript::MathUtils qw/opposite_deg reduce_deg reduce_rad/;
use AstroScript::Angles qw/ascendant/;


Readonly our $ARIES         => 'Aries';
Readonly our $PLACIDUS      => 'Placidus';
Readonly our $KOCH          => 'Koch';
Readonly our $REGIOMONTANUS => 'Regiomontanus';
Readonly our $MORINUS       => 'Morinus';
Readonly our $CAMPANUS      => 'Campanus';
Readonly our $WHOLESIGN     => 'WholeSign';
Readonly our $EQUAL_ASC     => 'EqualAsc';

our %ROUTINE = (
    $PLACIDUS      => [ sub{ _placidus(@_) }                       , 1 ],
    $KOCH          => [ sub{ _koch(@_) }                           , 1 ],
    $REGIOMONTANUS => [ sub{ _regiomontanus(@_) }                  , 1 ],
    $CAMPANUS      => [ sub{ _campanus(@_) }                       , 1 ],
    $MORINUS       => [ sub{ _morinus(@_) }                        , 0 ],
    $ARIES         => [ sub{ push @{$_[0]}, map{ $_* 30 } (0..11) }, 0 ],
    $WHOLESIGN     => [ sub{ _wholesign(@_) },                       0 ],
    $EQUAL_ASC     => [ sub{ _equal_asc(@_) },                       0 ],
);

# индексы таблицы %ROUTINE
use constant {
    FUNCTION => 0,
    ANGULAR  => 1,
};


# Returns number of an opposite cusp (zero based)
# Input: a cusp number
sub opp { ($_[0] + 6) % 12 }


# Placidus system.
#
# Returns array of cusps longitudes in deg2rad
# Named arguments:
# 1. right ascension of the meridian
# 2. ecliptic obliquity
# 3. geographic latitude
# (all in degrees)
sub _placidus {
    my $cusps = shift;
    my %arg  = @_;

    my ($rm, $ob, $la) = map { $arg{$_} } qw/rm ob la/;
    $la ||= 1E-6;

    my @csp = (10, 11, 1, 2);
    my @a = (3, 1.5, 1.5, 3);
    my @b = (30, 60, 120, 150);
    my $bo = deg2rad($ob);
    my $tan_ob = tan($bo);
    my $cos_ob = cos($bo);
    my $tan_la = tan(deg2rad($la));
    my $obla = $tan_ob * $tan_la;
    for (my $i = 0; $i < 4; $i++) {
        my ($y, $r2);
        if (($b[$i] == 30) || ($b[$i] == 60)) {
            $y = -1;
            $r2 = deg2rad($rm);
        } else {
            $y = 1;
            $r2 = deg2rad($rm + 180);
        }
        my $x = deg2rad($b[$i] + $rm);
        for (my $j = 0; $j < 10; $j++) {
            $x = acos($y * sin($x) * $obla) / $a[$i];
            $x = $r2 - $y * $x;
        }
        my $w = atan2(sin($x), $cos_ob * cos($x));
        my $id = $csp[$i];
        $cusps->[$id] = reduce_deg( rad2deg($w) );
        $cusps->[opp($id)] = opposite_deg($cusps->[$id]);
    }
}


sub _koch {
    my $cusps = shift;
    my %arg  = @_;

    my ($rm, $ob, $la) = map { $arg{$_} } qw/rm ob la/;
    $la //= 1E-6;

    my ($bo, $al, $mr) = map {deg2rad($_) } ($ob, $la, $rm);

    my $d = rad2deg(asin(tan($al) * tan(asin(sin($mr) * sin($bo)))));
    my $a = 2 * $d / 3;
    my $b = $d / 3;

    my @arr = (
        [10, -$a - 60],
        [11, -$b - 30],
        [ 1,  $b + 30],
        [ 2,  $a + 60],
    );
    for (@arr) {
        my ($i, $x) = @$_;
        $cusps->[$i] = ascendant($rm + $x, $ob, $la);
        $cusps->[opp($i)] = opposite_deg($cusps->[$i]);
    }
}


sub _regiomontanus {
    my $cusps = shift;
    my %arg  = @_;
    my ($rm, $ob, $la) = map { deg2rad($arg{$_}) } qw/rm ob la/;
    my $tn_the = tan($la);

    my $calc = sub {
        my $h = shift;
        my $rh = $rm + $h;
        my $r = atan2(sin($h) * $tn_the, cos($rh));
        reduce_deg(
            rad2deg(atan2(cos($r) * tan($rh), cos($r + $ob)))
        )
    };

    my @arr = map{ $calc->(deg2rad($_)) } (30, 60, 120, 150);
    my @idx = (10, 11, 1, 2);
    for (0..3) {
        my $n = $idx[$_];
        $cusps->[$n] = $arr[$_];
        $cusps->[opp($n)] = opposite_deg($arr[$_]);
    }
}

sub _campanus {
    my $cusps = shift;
    my %arg  = @_;
    my ($rm, $ob, $la) = map { deg2rad($arg{$_}) } qw/rm ob la/;
    my $sn_the = sin($la);
    my $cs_the = cos($la);
    my $rm90 = $rm + deg2rad(90);

    my $calc = sub {
        my $h = shift;
        my $sn_h = sin($h);
        my $d = $rm90 - atan2(cos($h), $sn_h * $cs_the);
        my $c = atan2(tan(asin($sn_the * $sn_h)), cos($d));
        reduce_deg(
            rad2deg(
                atan2(tan($d) * cos($c), cos($c + $ob))
            )
        )
    };

    my @arr = map{ $calc->(deg2rad($_)) } (30, 60, 120, 150);
    my @idx = (10, 11, 1, 2);
    for (0..3) {
        my $n = $idx[$_];
        $cusps->[$n] = $arr[$_];
        $cusps->[opp($n)] = opposite_deg($arr[$_]);
    }
}

sub _morinus {
    my $cusps = shift;
    my %arg  = @_;
    my ($rm, $ob) = map { deg2rad($arg{$_}) } qw/rm ob/;
    my $cs_eps = cos($ob);
    my ($r30, $r60) = map { deg2rad($_) } (30, 60);
    for( 0..11 ) {
        my $r = $rm + $r60 + $r30 * ($_ + 1);
        $cusps->[$_] = reduce_deg(
            rad2deg(
                atan2(sin($r) * $cs_eps, cos($r))
            )
        )
    }
}


sub _equal {
    my $start = shift;
    my $cusps = shift;
    $cusps->[$_] = reduce_deg( $start + $_ * 30 ) for 0..11
}


sub _equal_asc {
    my $cusps = shift;
    my %arg  = @_;
    _equal($arg{as}, $cusps)
}


sub _wholesign {
    my $cusps = shift;
    my %arg  = @_;
    my $z = int( $arg{as} / 30 ); # ascendant sign
    _equal($z * 30, $cusps);
}

sub cusps {
    my $sys  = shift;
    my %args = @_;
    my @cusps;

    if ( $ROUTINE{$sys}->[ANGULAR] ) {
        my $as = $args{as};
        my $mc = $args{mc};
        @cusps[0, 6, 9, 3] = ($as, opposite_deg($as), $mc, opposite_deg($mc));
    }

    $ROUTINE{$sys}->[FUNCTION]->(\@cusps, %args);
    \@cusps;
}

sub in_house {
    my ($lon, $cusps) = @_;
    for(0..11) {
        my $x0 = $cusps->[$_];
        my $x1 = $cusps->[($_ + 1) % 12];
        if ($x1 > $x0) {
            return $_ if $lon >= $x0 and $lon < $x1;
        }
        else {
            return $_ if $lon >= $x0 and $lon < 360;
            return $_ if $lon >= 0 and $lon < $x1;
        }
    }
    -1;
}



1;

__END__

=pod

=encoding UTF-8

=head1 NAME

AstroScript::Houses - Astrological houses.

=head1 VERSION

Version 0.01

=head1 SYNOPSYS

  use AstroScript::Houses qw/cusps :systems/;

  # $ramc = right ascension of the Meridian
  # $eps = obliquity of the ecliptic
  # $theta = geographical latitude

  my $arr = cusps($PLACIDUS, rm => $ramc, ob => $eps, la => $theta);
  # array contains longitudes of the 12 cusps

=head1 DESCRIPTION

Astrological Houses. Available house systems are:

=over

=item *

Quadrant-based systems: I<Placidus>, I<Koch>, I<Regiomontanus>, I<Campanus>.
Most of the Quadrant-based systems fail at extreme geographical latitudes.
To check, whether a latitude is extreme, use C<is_highlat> function from
L<AstroScript::Angles> package.

=item *

I<Morinus> system, works at extreme latitudes

=item *

Equal systems: I<Whole-Sign>, I<Equal Houses from the Ascendant> and conditional
I<Aries> system, meaning "no system".

=back


=head1 EXPORTED CONSTANTS

=over

=item * C<$PLACIDUS> — Placidus

=item * C<$KOCH> — Koch

=item * C<$REGIOMONTANUS> — Regiomontanus

=item * C<$MORINUS> — Morinus

=item * C<$CAMPANUS> — Campanus

=item * C<$WHOLESIGN> — Whole-Sign system

=item * C<$EQUAL_ASC> — Equal houses, started from the Ascendant.

=item * C<$ARIES> — "no system", which starts at 0 Aries and houses fit signs.

=item * C<@SYSTEMS> — array containing all the constants listed above.

=back

=head1 EXPORTED FUNCTIONS

=over

=item * L</cusps($system, %params)>

=item * L</in_house($x, $cusps)>

=item * L</opp($cusp_index)>

=back

=head2 cusps($system, %params)

Given system name and parameters, calculate longitudes of the 12 house cusps.

=head3 Positional Arguments:

=over

=item * $system - house system identifier, one of elements of C<@SYSTEMS> array.

=back

=head3 Named Arguments:

Depend on the system.

=over

=item *

B<as> I<Ascendant>. Required by all the systems except C<$ARIES>.

=item *

B<mc> I<Midheaven>. Required by all the Quadrant systems.

=item *

B<rm> I<Right Ascension of the meridian>, same as the I<Sidereal time> * 15.  Required by
all the Quadrant systems and Morinus.

=item *

B<ob> I<Obliquity of the ecliptic>. Required by all the Quadrant systems and Morinus.

=item *

B<la> I<Geographical latitude>. Required by all the Quadrant systems.

=back

=head2 in_house($x, $cusps)

Returns number of a house containing a given ecliptic point.

=head3 Arguments

=over

=item * B<$x> longitude of the point (degrees)

=item * B<$cusps> reference to array of house cusps longitudes (degrees)

=back

=head2 opp($cusp_index)

Given a cusp index, zero-based, return index of the opposite cusp.
E.g. C<opp(2) = 8>, C<opp(12) = 6>, etc.


=head1 AUTHOR

Sergey Krushinsky, C<< <krushinsky at gmail.com> >>


=head1 COPYRIGHT & LICENSE

Copyright 2009-2019 Sergey Krushinsky.

This library is free software; you can redistribute it and/or modify
it under the same terms as Perl itself.

=cut
