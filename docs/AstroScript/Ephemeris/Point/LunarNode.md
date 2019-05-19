# NAME

AstroScript::Ephemeris::Point::Node - Lunar Node

# SYNOPSIS

    use AstroScript::Ephemeris::Point::Node;
    my $node = AstroScript::Ephemeris::Point::Node->new();
    my $pos = $node->position($t); # ecliptical coordinates

# DESCRIPTION

Child class of [AstroScript::Ephemeris::Point](https:/github.com/skrushinsky/astroscript/docs/AstroScript/Ephemeris/Point.md), responsible for calculating
**True Lunar Node** position.

# METHODS

## AstroScript::Ephemeris::Point::LunarNode->new

Constructor.

## position($t, %options)

Given $t, Julian days from epoch 2000.0, in centuries, return ecliptic longitude.

# AUTHOR

Sergey Krushinsky, `<krushinsky at gmail.com>`

# COPYRIGHT AND LICENSE

Copyright (C) 2009-2019 by Sergey Krushinsky

This library is free software; you can redistribute it and/or modify
it under the same terms as Perl itself.