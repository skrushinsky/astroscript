# NAME

AstroScript::Aspects::Orbs - Base class for calculating orbs. Each descendant
must implement `is_aspect` method.

# SYNOPSIS

    package AstroScript::Aspects::Orbs::MyOrbsMethod;

    use base qw/package AstroScript::Aspects::Orbs/;
    ...

    sub new {
        my $class = shift;
        $class->SUPER::new( name => 'My Orbs Method');
    }


    sub is_aspect {
        my $self = shift;
        my ($src_id, $dst_id, $aspect, $arc) = @_;
        ... # check aspect, return true or false
    }

# DESCRIPTION

AstroScript::Aspects::Orbs - Base class for calculating orbs. Each descendant
must implement `is_aspect` method.

# METHODS

## AstroScript::Aspects::Orbs->new( name => str )

Constructor. **$name** is the unique system name.

## $self->name

Getter of **name** property.

## $self->is\_aspect($src\_id, $dst\_id, $aspect, $arc)

Are two bodies in given aspect?

### Arguments

- **$src\_id** — identifier of the first celestial body, string
- **$src\_id** — identifier of the second celestial body, string
- **$aspect** — instance of [AstroScript::Aspects::Aspect](https:/github.com/skrushinsky/astroscript/docs/AstroScript/Aspects/Aspect.md) class.
- **$arc** — angular distance between the two bodies in degrees.

### Return

_true_ if there is the two bodies are in given aspect, otherwise _false_.

# AUTHOR

Sergey Krushinsky, `<krushinsky at gmail.com>`

# COPYRIGHT AND LICENSE

Copyright (C) 2009-2019 by Sergey Krushinsky

This library is free software; you can redistribute it and/or modify
it under the same terms as Perl itself.