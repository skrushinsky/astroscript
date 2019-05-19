# NAME

AstroScript::Ephemeris - the main entry point for calculating planetary positions.

# SYNOPSIS

    use DateTime;
    use AstroScript::Ephemeris::Planet qw/@PLANETS/;
    use AstroScript::Ephemeris qw/planets/;
    use Data::Dumper;

    my $jd = DateTime->now->jd; # Standard Julian date for current moment
    my $t  = ($jd - 2451545) / 36525; # Convert Julian date to centuries since epoch 2000.0
                                      # for better accuracy, $t should be converted to Ephemeris time.
    my $iter = planets( $t, \@PLANETS ); # get iterator function for Sun. Moon and the planets.

    while ( my $result = $iter->() ) {
        my ($id, $co) = @$result;
        print $id, "\n", Dumper($co), "\n"; # geocentric longitude, latitude and distance from Earth
    }

# DESCRIPTION

Calculates positions of Sun, Moon, the 8 planets and Lunar Node. Algorithms are
based on _"Astronomy on the Personal Computer"_ by O.Montenbruck and Th.Pfleger,
C++ edition. The results are supposed to be precise enough for amateur's purposes.

# SUBROUTINES/METHODS

## planets($t, $ids, %options)

Returns iterator function, which, on its turn, returns on each pass a hashref,
containing coordinates of a celestial body:

- **x** — celestial longitude, arc-degrees
- **y** — celestial latitude, arc-degrees
- **z** — distance from Earth in A.U.
- **motion** — mean daily motion, degrees, if _with\_motion_ flag is set

See  the ["SYNOPSIS"](#synopsis)

### Positional Arguments:

- **$t** — time in centuries since epoch 2000.0; for better precision UTC should be converted to Ephemeris time (see [AstroScript::Time](https:/github.com/skrushinsky/astroscript/docs/AstroScript/Time.md));
- **$ids** — reference to an array of ids of celestial bodies to be calculated.

### Named Arguments

- **with\_motion** — optional flag; when set to _true_, there is additional _motion_ field in the result;  **false** by default.
- **true\_node** — optional flag; when set to _true_ (default), calculates _True Lunar Node_ instead of _Mean Node_ (if **$ids** contain `'LunarNode'`).

# SEE ALSO

- Oliver Montenbruck, Thomas Pfleger _"Astronomy on the Personal Computer"_, 4th edition>

# AUTHOR

Sergey Krushinsky, `<krushinsky at gmail.com>`

# COPYRIGHT AND LICENSE

Copyright (C) 2010-2019 by Sergey Krushinsky

This library is free software; you can redistribute it and/or modify
it under the same terms as Perl itself.