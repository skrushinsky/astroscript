package AstroScript::Angles;

use strict;
use warnings;
use Exporter qw/import/;
use POSIX qw /tan atan atan2 asin/;
use Math::Trig qw/deg2rad rad2deg :pi/;
use AstroScript::MathUtils qw/reduce_deg/;

our %EXPORT_TAGS = (
    all => [ qw/ascendant midheaven eastpoint vertex is_highlat/ ],
);
our @EXPORT_OK = ( @{ $EXPORT_TAGS{'all'} } );

our $VERSION = '1.00';

sub ascendant {
    my ( $ra, $ob, $la ) = map { deg2rad($_) } @_;
    my $y = -sin($ra) * cos($ob) - tan($la) * sin($ob);
    my $z = cos($ra);
    reduce_deg( rad2deg( atan2( $z, $y ) ) );
}

sub midheaven {
    my ( $ra, $ob ) = map { deg2rad($_) } @_;

    my $x = atan2(tan($ra), cos($ob));
    $x += pi if $x < 0;
    $x += pi if sin($ra) < 0;
    reduce_deg( rad2deg($x) );
}


sub eastpoint {
    my ( $ra, $ob ) = map { deg2rad($_) } @_;
    reduce_deg( rad2deg( atan2( cos($ra), -sin($ra) * cos($ob) ) ) );
}


sub vertex {
    my ( $ra, $ob, $la ) = @_;
    ascendant( $ra + 180, $ob, 90 - $la)
}


sub is_highlat { abs( $_[0] ) >= 90 - $_[1] }

1;

__END__

=pod

=encoding UTF-8

=head1 NAME

AstroScript::Angles - Calculation of some abstract points.

=head1 VERSION

Version 0.01

=head1 DESCRIPTION

AstroScript::Angles - Calculation of some abstract points related to diurnal
rotation of the Celestial Sphera.

=head1 EXPORT

=over

=item * L</ascendant($ra, $ob, $la)>

=item * L</midheaven($ra, $ob)>

=item * L</eastpoint($ra, $ob)>

=item * L</vertex($ra, $ob, $la)>

=item * L</is_highlat($la, $ob)>

=back

=head2 ascendant($ra, $ob, $la)

Ascendant (degrees).

The Ascendant (Asc or As), is the degree that is ascending on the eastern horizon
at the specific time and location of an event.

=head3 Arguments

=over

=item * B<$ra> — right ascension of meridian (degrees)

=item * B<$ob> — ecliptic obliquity (degrees)

=item * B<$la> — geographic latitude (degrees)

=back

=head2 midheaven($ra, $ob)

Midheaven (MC) in degrees.

The Midheaven is the highest point in a celestial object's apparent daily traverse
of the visible sky, at which the local meridian intersects with the ecliptic.

=head3 Arguments

=over

=item * B<$ra> — right ascension of meridian (degrees)

=item * B<$ob> — ecliptic obliquity (degrees)

=back

=head2 eastpoint($ra, $ob)

East Point (degrees).

East Point, or the Equatorial Ascendant, is the degree rising over the Eastern
Horizon at the Earth's equator at any given time. In the celestial sphere it
corresponds to the intersection of the ecliptic with a great circle containing
the celestial poles and the East point of the horizon.

=head3 Arguments

=over

=item * B<$ra> — right ascension of meridian (degrees)

=item * B<$ob> — ecliptic obliquity (degrees)

=back

=head2 vertex($ra, $ob, $la)

Vertex (degrees).

The Vertex is a point located in the western hemisphere of a chart
(the right-hand side) that represents the intersection of the ecliptic and the
prime vertical.

=head3 Arguments

=over

=item * B<$ra> — right ascension of meridian (degrees)

=item * B<$ob> — ecliptic obliquity (degrees)

=item * B<$la> — geographic latitude (degrees)

=back

=head2 is_highlat($la, $ob)

Returns 1 if a given geographic latitude is high (extreme), otherwise 0.

=head3 Arguments

=over

=item * B<$la> — geographic latitude (degrees)

=item * B<$ob> — ecliptic obliquity (degrees)

=back

=head1 AUTHOR

Sergey Krushinsky, C<< <krushinsky at gmail.com> >>


=head1 COPYRIGHT & LICENSE

Copyright 2009-2019 Sergey Krushinsky.

This library is free software; you can redistribute it and/or modify
it under the same terms as Perl itself.

=cut
