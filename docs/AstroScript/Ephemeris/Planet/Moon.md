# NAME

AstroScript::Ephemeris::Planet::Moon

# SYNOPSIS

    use AstroScript::Ephemeris::Planet::Moon;
    my $planet = AstroScript::Ephemeris::Planet::Moon->new();
    my $geo = $planet->position($t); #  apparent geocentric ecliptical coordinates

# DESCRIPTION

Child class of [AstroScript::Ephemeris::Planet](https:/github.com/skrushinsky/astroscript/docs/AstroScript/Ephemeris/Planet.md), responsible for calculating
**Moon** position.

# METHODS

## AstroScript::Ephemeris::Planet::Moon->new

Constructor.

## $self->position($t)

Geocentric ecliptic coordinates of the Moon

### Arguments

- **$t** — time in Julian centuries since J2000: (JD-2451545.0)/36525.0

### Returns

Hash of geocentric ecliptical coordinates.

- **x** — geocentric longitude, arc-degrees
- **y** — geocentric latitude, arc-degrees
- **z** — distance from Earth, AU

# AUTHOR

Sergey Krushinsky, `<krushinsky at gmail.com>`

# COPYRIGHT AND LICENSE

Copyright (C) 2009-2019 by Sergey Krushinsky

This library is free software; you can redistribute it and/or modify
it under the same terms as Perl itself.