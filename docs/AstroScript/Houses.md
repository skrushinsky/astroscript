# NAME

AstroScript::Houses - Astrological houses.

# VERSION

Version 0.01

# SYNOPSYS

    use AstroScript::Houses qw/cusps :systems/;

    # $ramc = right ascension of the Meridian
    # $eps = obliquity of the ecliptic
    # $theta = geographical latitude

    my $arr = cusps($PLACIDUS, rm => $ramc, ob => $eps, la => $theta);
    # array contains longitudes of the 12 cusps

# DESCRIPTION

Astrological Houses. Available house systems are:

- Quadrant-based systems: _Placidus_, _Koch_, _Regiomontanus_, _Campanus_.
Most of the Quadrant-based systems fail at extreme geographical latitudes.
To check, whether a latitude is extreme, use `is_highlat` function from
[AstroScript::Angles](https:/github.com/skrushinsky/astroscript/docs/AstroScript/Angles.md) package.
- _Morinus_ system, works at extreme latitudes
- Equal systems: _Whole-Sign_, _Equal Houses from the Ascendant_ and conditional
_Aries_ system, meaning "no system".

# EXPORTED CONSTANTS

- `$PLACIDUS` — Placidus
- `$KOCH` — Koch
- `$REGIOMONTANUS` — Regiomontanus
- `$MORINUS` — Morinus
- `$CAMPANUS` — Campanus
- `$WHOLESIGN` — Whole-Sign system
- `$EQUAL_ASC` — Equal houses, started from the Ascendant.
- `$ARIES` — "no system", which starts at 0 Aries and houses fit signs.
- `@SYSTEMS` — array containing all the constants listed above.

# EXPORTED FUNCTIONS

- ["cusps($system, %params)"](#cusps-system-params)
- ["in\_house($x, $cusps)"](#in_house-x-cusps)
- ["opp($cusp\_index)"](#opp-cusp_index)

## cusps($system, %params)

Given system name and parameters, calculate longitudes of the 12 house cusps.

### Positional Arguments:

- $system - house system identifier, one of elements of `@SYSTEMS` array.

### Named Arguments:

Depend on the system.

- **as** _Ascendant_. Required by all the systems except `$ARIES`.
- **mc** _Midheaven_. Required by all the Quadrant systems.
- **rm** _Right Ascension of the meridian_, same as the _Sidereal time_ \* 15.  Required by
all the Quadrant systems and Morinus.
- **ob** _Obliquity of the ecliptic_. Required by all the Quadrant systems and Morinus.
- **la** _Geographical latitude_. Required by all the Quadrant systems.

## in\_house($x, $cusps)

Returns number of a house containing a given ecliptic point.

### Arguments

- **$x** longitude of the point (degrees)
- **$cusps** reference to array of house cusps longitudes (degrees)

## opp($cusp\_index)

Given a cusp index, zero-based, return index of the opposite cusp.
E.g. `opp(2) = 8`, `opp(12) = 6`, etc.

# AUTHOR

Sergey Krushinsky, `<krushinsky at gmail.com>`

# COPYRIGHT & LICENSE

Copyright 2009-2019 Sergey Krushinsky.

This library is free software; you can redistribute it and/or modify
it under the same terms as Perl itself.