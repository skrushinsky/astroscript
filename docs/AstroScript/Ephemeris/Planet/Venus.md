# NAME

AstroScript::Ephemeris::Planet::Venus

# SYNOPSIS

    use AstroScript::Ephemeris::Planet::Venus;
    my $planet = AstroScript::Ephemeris::Planet::Venus->new();
    my $geo = $planet->position($t); #  apparent geocentric ecliptical coordinates

# DESCRIPTION

Child class of [AstroScript::Ephemeris::Planet](https:/github.com/skrushinsky/astroscript/docs/AstroScript/Ephemeris/Planet.md), responsible for calculating
**Venus** position.

# METHODS

## AstroScript::Ephemeris::Planet::Venus->new

Constructor.

## $self->heliocentric($t)

See description in [AstroScript::Ephemeris::Planet](https:/github.com/skrushinsky/astroscript/docs/AstroScript/Ephemeris/Planet.md).

# AUTHOR

Sergey Krushinsky, `<krushinsky at gmail.com>`

# COPYRIGHT AND LICENSE

Copyright (C) 2009-2019 by Sergey Krushinsky

This library is free software; you can redistribute it and/or modify
it under the same terms as Perl itself.