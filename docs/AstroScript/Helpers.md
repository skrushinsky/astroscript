# NAME

AstroScript::Helpers - Helper functions for scripts.

# VERSION

Version 1.00

# DESCRIPTION

Helper functions for scripts, mainly string related.

# EXPORT

- ["parse\_geocoords(l => number, m => number)"](#parse_geocoords-l-number-m-number)
- ["dmsz\_str($x, decimal => boolean)"](#dmsz_str-x-decimal-boolean)
- ["dms\_str($x)"](#dms_str-x)
- ["dms\_or\_dec\_str($x, decimal => boolean, places => N, sign => boolean)"](#dms_or_dec_str-x-decimal-boolean-places-n-sign-boolean)
- ["hms\_str($x, $decimal => boolean)"](#hms_str-x-decimal-boolean)
- ["latde\_str($h, $decimal => boolean)"](#latde_str-h-decimal-boolean)

# FUNCTIONS

## parse\_geocoords(l => number, m => number)

Parse geographical coordinates

### Named Arguments

- **l** — longitude in degrees
- **m** — latitude in degrees

### Returns

List of formatted longitude and latitude, e.g: `037E35`, `55N45`.

## dmsz\_str($x, decimal => boolean)

Given ecliptic longitude **$x**, return string with Zodiac position:
`12:30 Aqu` or `312.50 Aqu` depending on **decimal** option.

### Options

- **decimal** — return decimal degrees instead of degrees and minutes.

## dms\_str($x)

Given ecliptic longitude **$x**, return string of formatted degrees, minutes
and seconds, e.g.: `312:30:02`.

## dms\_or\_dec\_str($x, decimal => boolean, places => N, sign => boolean)

Format ecliptic longitude **$x**.

### Options

- **decimal** — return decimal degrees instead of degrees and minutes. Default is _false_
- **places** — number of arc-degrees digits. If `$x = 1`, `3` gives `001`, `2` gives `01`, `1` gives `1`. Default is **3**
- **sign** — if _true_, the number will be prefixed with **+** or **-**, depending on its sign. Default: _false_.

## hms\_str($x, $decimal => boolean)

Format time value **$x**.

### Options

- **decimal** — return decimal degrees instead of degrees and minutes.

## latde\_str($h, $decimal => boolean)

Format time value **$h**.

### Options

- **decimal** — return decimal degrees instead of degrees and minutes.

# SUPPORT

You can find documentation for this module with the perldoc command.

    perldoc AstroScript::CoCo

# AUTHOR

Sergey Krushinsky, `<krushinsky at gmail.com>`

# COPYRIGHT AND LICENSE

Copyright (C) 2009-2019 by Sergey Krushinsky

This library is free software; you can redistribute it and/or modify
it under the same terms as Perl itself.