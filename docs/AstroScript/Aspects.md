# NAME

AstroScript::Aspects - main class for calculating aspects.

# SYNOPSIS

    use Data::Dumper;
    use AstroScript::Ephemeris::Planet qw/@PLANETS/;
    use AstroScript::Aspects;

    my @targets = (
        {
            id => $MO,
            x  => 310.211
        },
        {
            id => $SU,
            x => 312.431
        },
        ...
    );
    # Use default options
    my $aspects = AstroScript::Aspects->new();
    my $src = {
        id => $JU,
        x  => 46.929
    };

    # iterator interface
    my $iter = $aspects->iterator($src, \@targets);
    while (my $asp = $iter->()) {
        print Dumper($asp);
        # {
        #     target => "Sun",
        #     aspect => AstroScript::Aspects::Aspect instance,
        #     arc    => 85.502,
        #     delta  => 4.498
        # }
    }

    # callback interface
    $aspects->find_aspects_to($src, \@targets, sub { print Dumper($asp)  });

# DESCRIPTION

Main class for determining aspects. Instance of this class holds some settings,
which must be known before doing calculations:

- type of orbs;
- which aspects we are interested in

See the [Constructor](/METHODS#AstroScript::Aspects-new-options) named arguments.

# EXPORTED CONSTANTS

## Aspects

All the constants are instances of [AstroScript::Aspects::Aspect](https:/github.com/skrushinsky/astroscript/docs/AstroScript/Aspects/Aspect.md) class. To
import them, use `:aspects` tag: `use AstroScript::Aspects qw/:aspects/;`

- $CONJUNCTION
- $VIGINTILE
- $QUINDECILE
- $SEMISEXTILE
- $DECILE
- $SEXTILE
- $SEMISQUARE
- $QUINTILE
- $SQUARE
- $TRIDECILE
- $TRINE
- $SESQUIQUADRATE
- $BIQUINTILE
- $QUINCUNX
- $OPPOSITION

## Miscellaneous

- `@ASPECTS` — array containing all of the aspects listed above. To import: `use AstroScript::Aspects qw /@ASPECTS/;`

# METHODS

## AstroScript::Aspects->new( %options )

Constructor.

### Named arguments:

- **orbs** — instance of [AstroScript::Aspects::Orbs](https:/github.com/skrushinsky/astroscript/docs/AstroScript/Aspects/Orbs.md) class. [AstroScript::Aspects::Orbs::AspectRatio](/AstroScript::Aspects::Orbs::AspectRatio) by default.
- **type\_flags** — combination of `$MAJOR`, `$MINOR` and `$KEPLER` flags. `$MAJOR` by default.

## $self->orbs

Readonly accessor. Returns instance of [AstroScript::Aspects::Orbs](https:/github.com/skrushinsky/astroscript/docs/AstroScript/Aspects/Orbs.md) class.

## $self->type\_flags

Readonly accessor. Returns integer, which is combination of `$MAJOR`, `$MINOR`
and `$KEPLER` flags, which are exported by [AstroScript::Aspects::Constants](https:/github.com/skrushinsky/astroscript/docs/AstroScript/Aspects/Constants.md)
module.

    use AstroScript::Aspects;
    use AstroScript::Aspects::Constants qw/:types/;

    my $aspects = AstroScript::Aspects->new(type_flags => ($MAJOR | $MINOR | $KEPLER))

    my $flags = $aspects->type_flags;
    say "Major aspects are used" if $flags & $MAJOR;
    say "Minor aspects are used" if $flags & $MINOR;
    say "Kepler aspects are used" if $flags & $KEPLER;

## $self->aspects

Readonly accessor. Returns arrayref to aspects taken into account. Each element
is an instance of [AstroScript::Aspects::Aspect](https:/github.com/skrushinsky/astroscript/docs/AstroScript/Aspects/Aspect.md) class. Content of the array is
determimned by **type\_flags** [constructor](https:/github.com/skrushinsky/astroscript/docs/AstroScript/Aspects->new\(&#x20;%options&#x20;\.md)) option.

## $self->find\_closest($src, $dst, $arc)

Given two planetary positions, find closest aspect between them. Only those
aspects are taken into account, which are returned by [$self->aspects](/$self->aspects) accessor.

### Arguments

- $src: planet id, string
- $dst: planet id, string
- $arc: distance in arc-degrees

### Returns

Closest aspect, instance of [AstroScript::Aspects::Aspect](https:/github.com/skrushinsky/astroscript/docs/AstroScript/Aspects/Aspect.md) class, or `undef`
if there are no aspects between the bodies.

## $self->iterator($src, $targets)

Given a planetary position, search its aspects to other planets. Iterator interface.

### Arguments

- $src: hash of `{ x => longitude in degrees, id => planet identifier }`
- $targets: reference to array of other bodies, each element represented by a hash similar to **$src** argument

### Returns

An iterator function. Each call to it returns a hash of:

- **target**: id of aspected planet (string)
- **aspect**: [AstroScript::Aspects::Aspect](https:/github.com/skrushinsky/astroscript/docs/AstroScript/Aspects/Aspect.md) instance
- **arc**: angular distance between planets (arc-degrees)
- **delta**: difference between actual distance and exact aspect value

When aspects are exhausted, the function returns `undef`.

### Example

    my $iter = $aspects->iterator($src, \@targets);
    while (my $res = $iter->()) {
        print Dumper($res);
    }

## $self->find\_aspects\_to($src, $targets, $callback)

Given a planetary position, search its aspects to other planets. Callback interface.

### Arguments

- **$src**: hash of `{ x => longitude in degrees, id => planet identifier }`
- **$targets**: reference to array of other bodies, each element represented by a hash similar to **$src** argument
- **$callback**: callback function, called each time an aspect is found with hash similar to that, which is returned by the iterator.

## AstroScript::Aspects->partition($positions, $callback)

Class method. Given array of planetary positions, yield each stellium or a single
planet in case that there are no other planets closer than the gap.

### Arguments

- **$positions**: arrayref of planetary positions: `[{ id => string, x => degrees }...]`

### Named Arguments

- **gap** minimal distance between groups (opional, _10°_ by default).
- **callback** callback function, required. It is called each time a new group is "closed", arguments are ids of the group members.

### Example

    use Data::Dumper;

    my @planets = (
      {
          id => $MO,
          x  => 310.211118039121
      },
      {
          id => $SU,
          x => 312.430798112358
      },
      ...
    ]

    AstroScript::Aspects->partition(
        \@planets,
        callback => sub { say Dumper(\@_) }
        # [ 'Sun', 'Moon']
    );

# SEE ALSO

- [AstroScript::Aspects::Aspect](https:/github.com/skrushinsky/astroscript/docs/AstroScript/Aspects/Aspect.md)
- [AstroScript::Aspects::Constants](https:/github.com/skrushinsky/astroscript/docs/AstroScript/Aspects/Constants.md)
- [AstroScript::Aspects::Orbs](https:/github.com/skrushinsky/astroscript/docs/AstroScript/Aspects/Orbs.md)

# AUTHOR

Sergey Krushinsky, `<krushinsky at gmail.com>`

# COPYRIGHT AND LICENSE

Copyright (C) 2009-2019 by Sergey Krushinsky

This library is free software; you can redistribute it and/or modify
it under the same terms as Perl itself.