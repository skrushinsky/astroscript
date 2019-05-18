package AstroScript;

use strict;
use warnings;

our $VERSION = '1.00';

1;
__END__


=pod

=encoding UTF-8

=head1 NAME

AstroScript - Astrological Ephemeris

=head1 DESCRIPTION

Library of astronomical calculations, aimed for astrology software.

=head1 ADVOCACY

There are many astronomical libraries available in the public domain. While
giving accurate results, they often suffer from lack of convenient API,
documentation and maintainability. Most of the source code is written in C, C++
or Java, and not dynamic languages. So, it is not easy for a layman to customize
them for her custom application, be it an online lunar calendar, horoscope or
tool for amateur sky observations. This library is an attempt to find a
middle-ground between precision on the one hand and compact, well organized
code on the other.

=head1 MODULES

=over

=item * L<AstroScript::MathUtils> — Core mathematical routines.

=item * L<AstroScript::Time> — Time-related routines.

=item * L<AstroScript::Ephemeris> — Positions of celestial bodies.

=item * L<AstroScript::Angles> — Some abstract points related to diurnal rotation of the Celestial Sphera: I<Ascendant>, I<Midheaven>, I<Vertex>, I<East Point>.

=item * L<AstroScript::CoCo> —  Coordinates conversions.

=item * L<AstroScript::Houses> —  Astrological houses, by the most used systems.

=item * L<AstroScript::Houses> —  Nutation and obliquity of ecliptic.

=back

=head1 ACKNOWLEDGMENTS

There are three sources, which I used:

=over

=item *

O.Montenbruck, T.Phleger, I<"Astronomy On The Personal Computer">,
Fourth Edition, Springer-Verlag, 2000.

=item *

Peter Duffett-Smith, I<"Astronomy With Your Personal Computer">,
Cambridge University Press, 1986.

=item *

Jean Meeus, I<"Astronomical Algorithms">, Willmann-Bell, Inc., 1991.

=back

=head1 AUTHOR

Sergey Krushinsky, C<< <krushinsky at gmail.com> >>

=head1 COPYRIGHT AND LICENSE

Copyright (C) 2010-2019 by Sergey Krushinsky

This library is free software; you can redistribute it and/or modify
it under the same terms as Perl itself.

=cut
