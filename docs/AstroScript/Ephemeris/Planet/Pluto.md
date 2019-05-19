# NAME

AstroScript::Ephemeris::Planet::Pluto

# SYNOPSIS

    use AstroScript::Ephemeris::Planet::Pluto;
    my $planet = AstroScript::Ephemeris::Planet::Pluto->new();
    my $geo = $planet->position($t); #  apparent geocentric ecliptical coordinates

# DESCRIPTION

Child class of [AstroScript::Ephemeris::Planet](https:/github.com/skrushinsky/astroscript/docs/AstroScript/Ephemeris/Planet.md), responsible for calculating
**Pluto** position.

The coordinates are first calculated relative to the fixed ecliptic of 1950, and
then transformed to the equinox of date. This method is nesessary because of
the high inclination of Pluto's orbit.

# CAVEATS

The routine is applicable only between years **1890** and **2100**.

    The reason for this is that the series expansion used was not derived from
    perturbation theory, but from a Fourier analysis of a numerically integrated
    ephemeris covering this period of time. Even a few years before 1890 or after
    2100, the errors in the calculated coordinates grow very sharply, reaqching
    values of more than 0.5 arc-degrees.

    — O.Montenbruck, Th.Pfleger "Astronomy on the Personal Computer"

# METHODS

## AstroScript::Ephemeris::Planet::Pluto->new

Constructor.

## $self->heliocentric($t)

See description in [AstroScript::Ephemeris::Planet](https:/github.com/skrushinsky/astroscript/docs/AstroScript/Ephemeris/Planet.md).

# AUTHOR

Sergey Krushinsky, `<krushinsky at gmail.com>`

# COPYRIGHT AND LICENSE

Copyright (C) 2009-2019 by Sergey Krushinsky

This library is free software; you can redistribute it and/or modify
it under the same terms as Perl itself.