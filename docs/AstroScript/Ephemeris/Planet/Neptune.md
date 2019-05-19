# NAME

AstroScript::Ephemeris::Planet::Neptune

# SYNOPSIS

    use AstroScript::Ephemeris::Planet::Neptune;
    my $planet = AstroScript::Ephemeris::Planet::Neptune->new();
    my $geo = $planet->position($t); #  apparent geocentric ecliptical coordinates

# DESCRIPTION

Child class of [AstroScript::Ephemeris::Planet](https:/github.com/skrushinsky/astroscript/docs/AstroScript/Ephemeris/Planet.md), responsible for calculating
**Neptune** position.

# METHODS

## AstroScript::Ephemeris::Planet::Neptune->new

Constructor.

## $self->heliocentric($t)

See description in [AstroScript::Ephemeris::Planet](https:/github.com/skrushinsky/astroscript/docs/AstroScript/Ephemeris/Planet.md).

# AUTHOR

Sergey Krushinsky, `<krushinsky at gmail.com>`

# COPYRIGHT AND LICENSE

Copyright (C) 2009-2019 by Sergey Krushinsky

This library is free software; you can redistribute it and/or modify
it under the same terms as Perl itself.