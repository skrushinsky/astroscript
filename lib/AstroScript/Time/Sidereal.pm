package AstroScript::Time::Sidereal;
use strict;
use warnings;

use Readonly;
use Exporter qw/import/;
use AstroScript::MathUtils qw/reduce_deg/;
use AstroScript::Time qw/jd_cent/;
use AstroScript::Nutation qw/nut_lon ecl_obl/;

our @EXPORT = qw/ramc/;

our $VERSION = '1.00';


Readonly::Scalar our $SOLAR_TO_SIDEREAL => 1.002737909350795;
# Difference in between Sidereal and Solar hour (the former is shorter)

sub ramc {
    my ( $jd, $lambda ) = @_;
    my $t = jd_cent($jd);

    # Correction for apparent S.T.
    my $corr = nut_lon($t) * cos( ecl_obl($t) ) / 3600;

    # Mean Local S.T.
    my $result =
      280.46061837 + 360.98564736629 * ( $jd - 2451545 ) +
      0.000387933 * $t * $t -
      $t**3 / 38710000 +
      $corr;

    $result -= $lambda;
    reduce_deg($result);
}

1;
__END__

=pod

=encoding UTF-8

=head1 NAME

AstroScript::Time::Sidereal - Sidereal time related calculations.

=head1 VERSION

Version 0.01


=head1 DESCRIPTION

Sidereal time related calculations.

=head1 EXPORT

=over

=item * L</ramc($jd, $lambda)>

=back

=head1 SUBROUTINES/METHODS

=head2 ramc($jd, $lambda)

Right Ascension of the Meridian

=head3 Arguments

=over

=item * B<$jd> — Standard Julian Date.

=item * B<$lambda> — geographic longitude in degrees, negative for East

=back

=head3 Returns

Right Ascension of Meridian, arc-degrees

=cut
