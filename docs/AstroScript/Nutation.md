# NAME

AstroScript::Nutation - nutation and obliquity of ecliptic

# VERSION

Version 0.01

# SYNOPSIS

    use AstroScript::Nutation qw/:all/;

    $delta_psi = nut_lon($t); # nutation in longitude
    $delta_eps = nut_obl($t); # nutation in ecliptic obliquity
    $epsilon = ecl_obl($t); # obliquity of ecliptic
    ...

# EXPORT

- ["$delta\_psi = nut\_lon($t)"](#delta_psi-nut_lon-t)
- ["$delta\_eps = nut\_obl($t)"](#delta_eps-nut_obl-t)
- ["$epsilon = ecl\_obl($t)"](#epsilon-ecl_obl-t)

# SUBROUTINES/METHODS

## $delta\_psi = nut\_lon($t)

Nutation in longitude (radians)

## $delta\_eps = nut\_obl($t)

Nutation in obliquity (radians)

## $epsilon = ecl\_obl($t)

Obliquity of ecliptic in radians. Accuracy is 0.01" between 1000 and 3000,
and a few arc-seconds after 10,000 years.

# AUTHOR

Sergey Krushinsky, `<krushinsky at gmail.com>`

# LICENSE AND COPYRIGHT

Copyright 2010-2019 Sergey Krushinsky.

This program is free software; you can redistribute it and/or modify it
under the terms of either: the GNU General Public License as published
by the Free Software Foundation; or the Artistic License.

See http://dev.perl.org/licenses/ for more information.