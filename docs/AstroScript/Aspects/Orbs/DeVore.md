# NAME

AstroScript::Ephemeris::Aspects::Orbs::DeVore

# SYNOPSIS

    use AstroScript::Ephemeris::Aspects::Orbs::DeVore;
    use AstroScript::Ephemeris::Planet qw/:ids/;

    # create object with default moieties
    my $orbs = AstroScript::Ephemeris::Aspects::Orbs::DeVore->()
    # Are Moon and Sun in conjunction, given their angular distance is 4.0 arc-degrees?
    my $b = $orbs->is_aspect($MO, $SU, $CONJUNCTION, 4); # true

# DESCRIPTION

Some modern astrologers believe that orbs are based on aspects.
The values are from _"Encyclopaedia of Astrology"_ by Nicholas deVore.

# METHODS

## AstroScript::Aspects::Orbs::DeVore->new

AstroScript::Aspects::Orbs::DeVore->new( $ranges => hashref )
AstroScript::Aspects::Orbs::DeVore->new( $ranges => hashref )

Constructor.

### Options

- **ranges**, hashref of `{ ASPECT => [$min, $max]... }`

#### Default ranges

- Conjunction => \[-10.0, 6.0\]
- Vigintile => \[17.5, 18.5\]
- Quindecile => \[23.5, 24.5\]
- Semisextile => \[28.0, 31.0\]
- Decile => \[35.5, 36.5\]
- Sextile => \[56, 63\]
- Semisquare => \[42.0, 49.0\]
- Quintile => \[71.5, 72.5\]
- Square => \[84.0, 96.0\]
- Tridecile => \[107.5, 108.5\]
- Trine => \[113.0, 125.0\]
- Sesquiquadrate => \[132.0, 137.0\]
- Biquintile => \[143.5, 144.5\]
- Quincunx => \[148.0, 151.0\]
- Opposition => \[174, 186\]

## $self->ranges

Getter of **ranges** property.

## $self->is\_aspect($src\_id, $dst\_id, $aspect, $arc)

See [description in the parent class ](/&#x20;AstroScript::Aspects::Orbs).

# AUTHOR

Sergey Krushinsky, `<krushinsky at gmail.com>`

# COPYRIGHT AND LICENSE

Copyright (C) 2009-2019 by Sergey Krushinsky

This library is free software; you can redistribute it and/or modify
it under the same terms as Perl itself.