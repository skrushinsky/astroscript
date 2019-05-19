# NAME

AstroScript::Ephemeris::Aspects::Orbs::Dariot

# SYNOPSIS

    use AstroScript::Ephemeris::Aspects::Orbs::Dariot;
    use AstroScript::Ephemeris::Planet qw/:ids/;

    my $orbs = AstroScript::Ephemeris::Aspects::Orbs::Dariot->new()
    # Are Moon and Sun in conjunction, given their angular distance is 4.0 arc-degrees?
    my $b = $orbs->is_aspect($MO, $SU, $CONJUNCTION, 4); # true

# DESCRIPTION

_Claude Dariot_ (1533-1594), introduced the so called _'moieties'_ (mean-values)
when calculating orbs. According to Dariot, Mercury and the Moon enter completion
(application) of any aspect at a  distance of 9½° degrees - the total of their
respective moieties (Mercury = 3½° + Moon = 6°). This method became the standard
for European Renaissance astrologers.

The method does not take into account the nature of aspects.

# METHODS

## AstroScript::Aspects::Orbs::Dariot->new

AstroScript::Aspects::Orbs::Dariot->new()
AstroScript::Aspects::Orbs::Dariot->new(moieties => hashref, default\_moiety => scalar)

Constructor.

### Options

- **moieties**, hashref of `{ PLANET_ID => $value... }`
- **default\_moiety**, number, used if a body id not in ["moieties"](#moieties) hash. Default: **4**.

#### Default moieties

- `$MO` =>  12.0
- `$SU` =>  15.0
- `$ME` =>  7.0
- `$VE` =>  7.0
- `$MA` =>  8.0
- `$JU` =>  9.0
- `$SA` =>  9.0
- `$UR` =>  6.0
- `$NE` =>  6.0
- `$PL` =>  5.0

## $self->moieties

Getter of **moieties** property.

## $self->default\_moiety

Getter of **default\_moiety** property.

## $self->moiety($planet\_id)

Return moiety for given celestial body, or ["$self->default\_moiety"](#self-default_moiety), if the body
is not registered in  ["$self->default\_moieties"](#self-default_moieties).

## $self->calculate\_orb($src\_id, $dst\_id)

Calculate orb between celestial bodies **$src\_id** and **$dst\_id**.

## $self->is\_aspect($src\_id, $dst\_id, $aspect, $arc)

See [description in the parent class ](/&#x20;AstroScript::Aspects::Orbs).

# SEE ALSO

- AstroScript::Aspects
- AstroScript::Aspects::Orbs

# AUTHOR

Sergey Krushinsky, `<krushinsky at gmail.com>`

# COPYRIGHT AND LICENSE

Copyright (C) 2009-2019 by Sergey Krushinsky

This library is free software; you can redistribute it and/or modify
it under the same terms as Perl itself.