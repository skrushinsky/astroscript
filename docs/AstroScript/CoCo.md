# NAME

AstroScript::CoCo - Coordinates conversions.

# VERSION

Version 0.01

# DESCRIPTION

Celestial sphera related calculations used by AstroScript modules.

# EXPORT

- ["equ2ecl($alpha, $delta, $epsilon)"](#equ2ecl-alpha-delta-epsilon)
- ["ecl2equ($lambda, $beta, $epsilon)"](#ecl2equ-lambda-beta-epsilon)

# FUNCTIONS

## equ2ecl($alpha, $delta, $epsilon)

Conversion of equatorial into ecliptic coordinates

### Arguments

- **$alpha** — right ascension
- **$delta** — declination
- **$epsilon** — ecliptic obliquity

### Returns

Ecliptic coordinates:

- **$lambda**
- **$beta**

All arguments and return values are in degrees.

## ecl2equ($lambda, $beta, $epsilon)

Conversion of ecliptic into equatorial coordinates

### Arguments

- **$lambda** — celestial longitude
- **$beta** — celestial latitude
- **$epsilon** — ecliptic obliquity

### Returns

Equatorial coordinates:

- **$alpha** — right ascension
- **$delta** — declination

All arguments and return values are in degrees.

# SUPPORT

You can find documentation for this module with the perldoc command.

    perldoc AstroScript::CoCo

# AUTHOR

Sergey Krushinsky, `<krushinsky at gmail.com>`

# COPYRIGHT AND LICENSE

Copyright (C) 2009-2019 by Sergey Krushinsky

This library is free software; you can redistribute it and/or modify
it under the same terms as Perl itself.