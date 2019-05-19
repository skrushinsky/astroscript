# NAME

AstroScript::Aspects::Aspect - Base class for an aspect.

# SYNOPSIS

    package AstroScript::Aspects::Aspect::Mercury;
    use base qw/AstroScript::Aspects::Aspect/;
    ...

    sub  heliocentric {
      # implement the method
    }

# DESCRIPTION

Base class for an aspect. In most cases there is no need to use this class,
unless you wich to use some rare experimental aspect. All the standard aspects
are created and exported by [AstroScript::Aspects](https:/github.com/skrushinsky/astroscript/docs/AstroScript/Aspects.md) module.

# METHODS

## AstroScript::Aspects::Aspect->new( %options )

Constructor.

### Named arguments:

- **name** — the name
- **brief\_name** — 3-letters identificator for tables
- **value** — arc-distance in degrees, e.g. 120 for _trine_.
- **influence** — one of constants exported by [AstroScript::Aspects::Constants](https:/github.com/skrushinsky/astroscript/docs/AstroScript/Aspects/Constants.md):
`$POSITIVE`, `$NEGATIVE`, `$NEUTRAL`, `$CREATIVE`.
- **type** — one of constants exported by [AstroScript::Aspects::Constants](https:/github.com/skrushinsky/astroscript/docs/AstroScript/Aspects/Constants.md):
`$MAJOR`, `$MINOR`, `$KEPLER`.

## $self->name

Read-only accessor for aspect's name

## $self->brief\_name

Read-only accessor for  3-letters identificator

## $self->value

arc-distance in degrees

## $self->influence

one of constants exported by [AstroScript::Aspects::Constants](https:/github.com/skrushinsky/astroscript/docs/AstroScript/Aspects/Constants.md):
`$POSITIVE`, `$NEGATIVE`, `$NEUTRAL`, `$CREATIVE`.

## $self->type

one of constants exported by [AstroScript::Aspects::Constants](https:/github.com/skrushinsky/astroscript/docs/AstroScript/Aspects/Constants.md):
`$MAJOR`, `$MINOR`, `$KEPLER`.

# AUTHOR

Sergey Krushinsky, `<krushinsky at gmail.com>`

# COPYRIGHT AND LICENSE

Copyright (C) 2009-2019 by Sergey Krushinsky

This library is free software; you can redistribute it and/or modify
it under the same terms as Perl itself.