# NAME

AstroScript::Core::MathUtils - Core mathematical routines used by AstroScript modules.

# VERSION

Version 0.01

# SYNOPSIS

    use AstroScript::Core::MathUtils qw/dms/;

    my ($d, $m, $s) = dms(55.75); # (55, 45, 0)
    ...

# EXPORT

- ["frac($x)"](#frac-x)
- ["frac360($x)"](#frac360-x)
- ["dms($x)"](#dms-x)
- ["hms($x)"](#hms-x)
- ["zdms($x)"](#zdms-x)
- ["ddd($deg\[, $min\[, $sec\]\])"](#ddd-deg-min-sec)
- ["polynome($t, @terms)"](#polynome-t-terms)
- ["to\_range($x, $range)"](#to_range-x-range)
- ["reduce\_deg($x)"](#reduce_deg-x)
- ["reduce\_rad($x)"](#reduce_rad-x)
- ["opposite\_deg($x)"](#opposite_deg-x)
- ["opposite\_rad($x)"](#opposite_rad-x)
- ["angle\_c($x, $y)"](#angle_c-x-y)
- ["angle\_c\_rad($x, $y)"](#angle_c_rad-x-y)
- ["angle\_c\_rad($x, $y)"](#angle_c_rad-x-y)
- ["angle\_s($x1, $y1, $x2, $y2)"](#angle_s-x1-y1-x2-y2)
- ["diff\_angle($a, $b, $mode='degrees')"](#diff_angle-a-b-mode-degrees)
- ["diff\_angle($a, $b, $mode='degrees')"](#diff_angle-a-b-mode-degrees)
- ["rectangular($r, $theta, $phi)"](#rectangular-r-theta-phi)
- ["spherical($x, $y, $z)"](#spherical-x-y-z)

# SUBROUTINES

## frac($x)

Fractional part of a decimal number.

## frac360($x)

Range function, similar to ["to\_range($x, $range)"](#to_range-x-range), used with polinomial function for better accuracy.

## dms($x)

Given decimal hours (or degrees), return nearest hours (or degrees), int,
minutes, int, and seconds, float.

### Positional arguments:

- decimal value, 0..360 for angular mode, 0..24 for time

### Named arguments:

- **places** (optional) amount of required sexadecimal values to be returned (1-3);
                  default = 3 (degrees/hours, minutes, seconds)

### Returns:

- array of degrees (int), minutes (int), seconds (float)

## hms($x)

Alias for ["dms"](#dms)

## zdms($x)

Converts decimal degrees to zodiac sign number (zero based), zodiac degrees, minutes and seconds.

### Positional arguments:

- decimal value, 0..360 for angular mode, 0..24 for time

### Returns:

- array of zodiac sign (0-11), degrees (int), minutes (int), seconds (float)

## ddd($deg\[, $min\[, $sec\]\])

Converts sexadecimal values to decimal.

### Arguments

> 1 to 3 sexadecimal values, such as: degrees, minutes and
> seconds, or degrees and minutes, or just degrees:
>
> - `ddd(11)`
> - `ddd(11, 46)`
> - `ddd(11, 46, 20)`
>
> If any non-zero argument is negative, the result is negative.
>
> - `ddd(-11, 46, 0) = -11.766666666666667`
> - `ddd(11, -46, 0) = 11.766666666666667`
>
> Negative sign in wrong position is ignored.

### Returns:

- decimal (degrees or hours)

## polynome($t, @terms)

Calculates polynome: $a1 + $a2\*$t + $a3\*$t\*$t + $a4\*$t\*$t\*$t...

### Arguments

- $t coefficient, in astronomical routines usually time in centuries
- any number of decimal values

### Returns:

- decimal number

## to\_range($x, $range)

Reduces $x to 0 >= $x < $range

### Arguments

- number to reduce
- limit (non-inclusive), e.g: 360 for degrees, 24 for hours

### Returns

- number

## reduce\_deg($x)

Reduces $x to 0 >= $x < 360

## reduce\_rad($x)

Reduces $x to 0 >= $x < pi2

## opposite\_deg($x)

Returns opposite degree.

## opposite\_rad($x)

Returns opposite radian.

## angle\_c($x, $y)

Calculate shortest arc in dergees between $x and $y.

## angle\_c\_rad($x, $y)

Calculates shortest arc in radians between $x and $y.

## angle\_s($x1, $y1, $x2, $y2)

Calculates arc between 2 points on a sphera.
Expected arguments: 2 pairs of coordinates (X, Y) of the 2 points.

The coordinates may be ecliptic, equatorial or horizontal.

## diff\_angle($a, $b, $mode='degrees')

Return angle `$b - $a`, accounting for circular values.

Parameters $a and $b should be in the range 0..pi\*2 or 0..360, depending on
optional **$mode** argument. The result will be in the range _-pi..pi_ or _-180..180_.
This allows us to directly compare angles which cross through 0:
_359 degress... 0 degrees... 1 degree..._ etc.

### Positional Arguments

- **$a** first angle, in radians or degrees
- **$b** second angle, in radians or degrees

### Named Arguments

- **$mode** `"degrees"` (default) or `"radians"`, case insensitive.

## sine($x)

Calculate sin(phi); phi in units of 1 revolution = 360 degrees

## rectangular($r, $theta, $phi)

Conversion of spherical coordinates (r,theta,phi) into rectangular (x,y,z).

### Arguments

- $r, distance from the origin;
- $theta (in radians) corresponding to \[-90 deg, +90 deg\];
- phi (in radians) corresponding to \[-360 deg, +360 deg\])

### Returns

Rectangular coordinates:

- $x
- $y
- $z

## spherical($x, $y, $z)

Conversion of rectangular coordinates (x,y,z) into spherical (r,theta,phi).

### Arguments

- $x
- $y
- $z

### Returns

Spherical coordinates:

- $r
- $theta
- $phi

# AUTHOR

Sergey Krushinsky, `<krushinsky at gmail.com>`

# COPYRIGHT & LICENSE

Copyright 2009-2019 Sergey Krushinsky.

This library is free software; you can redistribute it and/or modify
it under the same terms as Perl itself.