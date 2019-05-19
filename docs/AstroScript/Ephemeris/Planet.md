# NAME

AstroScript::Ephemeris::Planet - Base class for a planet.

# SYNOPSIS

    package AstroScript::Ephemeris::Planet::Mercury;
    use base qw/AstroScript::Ephemeris::Planet/;
    ...

    sub  heliocentric {
      # implement the method
    }

# DESCRIPTION

Base class for a planet. Designed to be extended. Used internally in
AstroScript::Ephemeris modules. Subclasses must implement **heliocentric** method.

# SUBROUTINES/METHODS

## $planet = AstroScript::Ephemeris::Planet->new( $id )

Constructor. **$id** is identifier from `@PLANETS` array (See ["EXPORTED CONSTANTS"](#exported-constants)).

## $xyz = $self->position($t, $sun)

Geocentric ecliptic coordinates of a planet

### Arguments

- **$t** — time in Julian centuries since J2000: (JD-2451545.0)/36525.0
- **$sun** — ecliptic geocentric coordinates of the Sun (hashref with **'x'**, **'y'**, **'z'** keys)

### Returns

Hash of geocentric ecliptical coordinates.

- **x** — geocentric longitude, arc-degrees
- **y** — geocentric latitude, arc-degrees
- **z** — distance from Earth, AU

## $self->heliocentric($t)

Given time in centuries since epoch 2000.0, calculate apparent geocentric
ecliptical coordinates `($l, $b, $r)`.

- **$l** — longitude, radians
- **$b** — latitude, radians
- **$r** — distance from Earth, A.U.

# EXPORTED CONSTANTS

- `$MO` — Moon
- `$SU` — Sun
- `$ME` — Mercury
- `$VE` — Venus
- `$MA` — Mars
- `$JU` — Jupiter
- `$SA` — Saturn
- `$UR` — Uranus
- `$NE` — Neptune
- `$PL` — Pluto
- `@PLANETS` — array containing all the ids listed above

# AUTHOR

Sergey Krushinsky, `<krushinsky at gmail.com>`

# COPYRIGHT AND LICENSE

Copyright (C) 2009-2019 by Sergey Krushinsky

This library is free software; you can redistribute it and/or modify
it under the same terms as Perl itself.