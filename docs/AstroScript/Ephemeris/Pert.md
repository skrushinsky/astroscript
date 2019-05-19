# NAME

AstroScript::Ephemeris::Pert - Calculation of perturbations.

# SYNOPSIS

    use AstroScript::Ephemeris::Pert qw /pert/;

    ($dl, $dr, $db) = (0, 0, 0); # Corrections in longitude ["],
    $pert_cb = sub { $dl += $_[0]; $dr += $_[1]; $db += $_[2] };

    # Perturbations by Venus
    $term
      = pert( T     => $t,
              M     => $m1,
              m     => $m2,
              I_min =>-1,
              I_max => 9,
              i_min =>-5,
              i_max => 0,
              callback => $pert_cb);

    # Perturbations by the Earth
    $term
      = pert( T     => $t,
              M     => $m1,
              m     => $m3,
              I_min => 0,
              I_max => 2,
              i_min =>-4,
              i_max =>-1,
              callback => $pert_cb);

# DESCRIPTION

Calculates perturbations for Sun, Moon and the 8 planets. Used internally by AstroScript::Ephemeris.

## EXPORT

- [pert(%args)](/pert\(%args\))
- ["addthe($a, $b, $c, $d)"](#addthe-a-b-c-d)

# SUBROUTINES/METHODS

## pert(%args)

Calculates perturbations to ecliptic heliocentric coordinates of the planet.

### Named arguments

- $t — time in centuries since epoch 2000.0
- M, m, I\_min, I\_max, i\_min, i\_max — misc. internal indices
- callback — reference to a function which receives corrections to 3
coordinates and typically applies them (see the example above)

## addthe($a, $b, $c, $d)

Calculates `c=cos(a1+a2)` and `s=sin(a1+a2)` from the addition theorems for
`c1=cos(a1), s1=sin(a1), c2=cos(a2) and s2=sin(a2)`

### Arguments

c1, s1, c2, s2

# SEE ALSO

- Oliver Montenbruck, Thomas Pfleger "Astronomy on the Personal Computer", 4th edition

# AUTHOR

Sergey Krushinsky, `<krushinsky at gmail.com>`

# COPYRIGHT AND LICENSE

Copyright (C) 2009-2019 by Sergey Krushinsky

This library is free software; you can redistribute it and/or modify
it under the same terms as Perl itself.