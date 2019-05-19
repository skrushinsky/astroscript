# NAME

AstroScript::Angles - Calculation of some abstract points.

# VERSION

Version 0.01

# DESCRIPTION

AstroScript::Angles - Calculation of some abstract points related to diurnal
rotation of the Celestial Sphera.

# EXPORT

- ["ascendant($ra, $ob, $la)"](#ascendant-ra-ob-la)
- ["midheaven($ra, $ob)"](#midheaven-ra-ob)
- ["eastpoint($ra, $ob)"](#eastpoint-ra-ob)
- ["vertex($ra, $ob, $la)"](#vertex-ra-ob-la)
- ["is\_highlat($la, $ob)"](#is_highlat-la-ob)

## ascendant($ra, $ob, $la)

Ascendant (degrees).

The Ascendant (Asc or As), is the degree that is ascending on the eastern horizon
at the specific time and location of an event.

### Arguments

- **$ra** — right ascension of meridian (degrees)
- **$ob** — ecliptic obliquity (degrees)
- **$la** — geographic latitude (degrees)

## midheaven($ra, $ob)

Midheaven (MC) in degrees.

The Midheaven is the highest point in a celestial object's apparent daily traverse
of the visible sky, at which the local meridian intersects with the ecliptic.

### Arguments

- **$ra** — right ascension of meridian (degrees)
- **$ob** — ecliptic obliquity (degrees)

## eastpoint($ra, $ob)

East Point (degrees).

East Point, or the Equatorial Ascendant, is the degree rising over the Eastern
Horizon at the Earth's equator at any given time. In the celestial sphere it
corresponds to the intersection of the ecliptic with a great circle containing
the celestial poles and the East point of the horizon.

### Arguments

- **$ra** — right ascension of meridian (degrees)
- **$ob** — ecliptic obliquity (degrees)

## vertex($ra, $ob, $la)

Vertex (degrees).

The Vertex is a point located in the western hemisphere of a chart
(the right-hand side) that represents the intersection of the ecliptic and the
prime vertical.

### Arguments

- **$ra** — right ascension of meridian (degrees)
- **$ob** — ecliptic obliquity (degrees)
- **$la** — geographic latitude (degrees)

## is\_highlat($la, $ob)

Returns 1 if a given geographic latitude is high (extreme), otherwise 0.

### Arguments

- **$la** — geographic latitude (degrees)
- **$ob** — ecliptic obliquity (degrees)

# AUTHOR

Sergey Krushinsky, `<krushinsky at gmail.com>`

# COPYRIGHT & LICENSE

Copyright 2009-2019 Sergey Krushinsky.

This library is free software; you can redistribute it and/or modify
it under the same terms as Perl itself.