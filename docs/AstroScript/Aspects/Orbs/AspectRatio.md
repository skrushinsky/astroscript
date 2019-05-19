# NAME

AstroScript::Ephemeris::Aspects::Orbs::AspectRatio

# SYNOPSIS

    use AstroScript::Ephemeris::Aspects::Orbs::AspectRatio;
    use AstroScript::Ephemeris::Planet qw/:ids/;

    my $orbs = AstroScript::Ephemeris::Aspects::Orbs::AspectRatio->()
    # Are Moon and Sun in conjunction, given their angular distance is 4.0 arc-degrees?
    my $b = $orbs->is_aspect($MO, $SU, $CONJUNCTION, 4); # true

# DESCRIPTION

Combined approach. For major aspects classic (_Dariot_) method is applied.
For minor and kepler aspects we apply to the classic orb value a
special coefficient: by default, 0.6 (60%) for minor and 0.4 (40%) for Keplerian.

## AstroScript::Aspects::Orbs::AspectRatio->new

    AstroScript::Aspects::Orbs::AspectRatio->new()
    AstroScript::Aspects::Orbs::AspectRatio->new(%options)

Constructor.

### Options

- **moieties**, hashref, see [AstroScript::Ephemeris::Aspects::Orbs::Dariot](https:/github.com/skrushinsky/astroscript/docs/AstroScript/Ephemeris/Aspects/Orbs/Dariot.md)
- **default\_moiety**, number, , see [AstroScript::Ephemeris::Aspects::Orbs::Dariot](https:/github.com/skrushinsky/astroscript/docs/AstroScript/Ephemeris/Aspects/Orbs/Dariot.md)
- **minor\_coeff**, coefficient for Minor aspects. Default: **0.6**.
- **minor\_coeff**, coefficient for Kepler aspects. Default: **0.4**.

## $self->minor\_coeff

Getter of **minor\_coeff** property.

## $self->kepler\_coeff

Getter of **kepler\_coeff** property.

## $self->is\_aspect($src\_id, $dst\_id, $aspect, $arc)

See [description in the parent class ](/&#x20;AstroScript::Aspects::Orbs).

# SEE ALSO

[AstroScript::Ephemeris::Aspects::Orbs::Dariot](https:/github.com/skrushinsky/astroscript/docs/AstroScript/Ephemeris/Aspects/Orbs/Dariot.md)

# AUTHOR

Sergey Krushinsky, `<krushinsky at gmail.com>`

# COPYRIGHT AND LICENSE

Copyright (C) 2009-2019 by Sergey Krushinsky

This library is free software; you can redistribute it and/or modify
it under the same terms as Perl itself.