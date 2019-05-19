# NAME

AstroScript - Astrological Ephemeris

# DESCRIPTION

Library of astronomical calculations, aimed for astrology software.

# ADVOCACY

There are many astronomical libraries available in the public domain. While
giving accurate results, they often suffer from lack of convenient API,
documentation and maintainability. Most of the source code is written in C, C++
or Java, and not dynamic languages. So, it is not easy for a layman to customize
them for her custom application, be it an online lunar calendar, horoscope or
tool for amateur sky observations. This library is an attempt to find a
middle-ground between precision on the one hand and compact, well organized
code on the other.

# MODULES

- [AstroScript::MathUtils](https:/github.com/skrushinsky/astroscript/docs/AstroScript/MathUtils.md) — Core mathematical routines.
- [AstroScript::Time](https:/github.com/skrushinsky/astroscript/docs/AstroScript/Time.md) — Time-related routines.
- [AstroScript::Ephemeris](https:/github.com/skrushinsky/astroscript/docs/AstroScript/Ephemeris.md) — Positions of celestial bodies.
- [AstroScript::Angles](https:/github.com/skrushinsky/astroscript/docs/AstroScript/Angles.md) — Some abstract points related to diurnal rotation of the Celestial Sphera: _Ascendant_, _Midheaven_, _Vertex_, _East Point_.
- [AstroScript::CoCo](https:/github.com/skrushinsky/astroscript/docs/AstroScript/CoCo.md) —  Coordinates conversions.
- [AstroScript::Houses](https:/github.com/skrushinsky/astroscript/docs/AstroScript/Houses.md) —  Astrological houses, by the most used systems.
- [AstroScript::Nutation](https:/github.com/skrushinsky/astroscript/docs/AstroScript/Nutation.md) —  Nutation and obliquity of ecliptic.

# ACKNOWLEDGMENTS

There are three sources, which I used:

- O.Montenbruck, T.Phleger, _"Astronomy On The Personal Computer"_,
Fourth Edition, Springer-Verlag, 2000.
- Peter Duffett-Smith, _"Astronomy With Your Personal Computer"_,
Cambridge University Press, 1986.
- Jean Meeus, _"Astronomical Algorithms"_, Willmann-Bell, Inc., 1991.

# AUTHOR

Sergey Krushinsky, `<krushinsky at gmail.com>`

# COPYRIGHT AND LICENSE

Copyright (C) 2010-2019 by Sergey Krushinsky

This library is free software; you can redistribute it and/or modify
it under the same terms as Perl itself.