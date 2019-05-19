# NAME

AstroScript::Ephemeris::Point - Base class for miscallenous points of the Celestial Sphere.

# SYNOPSIS

    package AstroScript::Ephemeris::Point::LunarNode;
    use base qw/AstroScript::Ephemeris::Point/;
    use AstroScript::Ephemeris::Point qw/$LN/;
    ...

      sub  new {
          sub new {
              my $class = shift;
              $class->SUPER::new( id => $LN );
          }
      }

# DESCRIPTION

Base class for a planet. Designed to be extended. Used internally in
AstroScript::Ephemeris modules.

The interface is similar to that of [AstroScript::Ephemeris::Planet](https:/github.com/skrushinsky/astroscript/docs/AstroScript/Ephemeris/Planet.md). Subclasses
must implement:

- new(), the constructor
- position($t, %options)

# EXPORTED CONSTANTS

- **$LN** Ascending Lunar Node
- **$AS** Ascendant
- **$MC** MidHeaven
- **$EP** East Point
- **$VX** Vertex
- **@POINTS** all of the above in array

# AUTHOR

Sergey Krushinsky, `<krushinsky at gmail.com>`

# COPYRIGHT AND LICENSE

Copyright (C) 2009-2019 by Sergey Krushinsky

This library is free software; you can redistribute it and/or modify
it under the same terms as Perl itself.