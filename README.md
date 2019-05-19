# AstroScript

Perl Library of astronomical calculations, aimed for astrology software.

## Advocacy

There are many astronomical libraries available in the public domain. While
giving accurate results, they often suffer from lack of convenient API,
documentation and maintainability. Most of the source code is written in C, C++
or Java, and not dynamic languages. So, it is not easy for a layman to customize
them for her custom application, be it an online lunar calendar, horoscope or
tool for amateur sky observations. This library is an attempt to find a
middle-ground between precision on the one hand and compact, well organized
code on the other.

Most of the calculations are based on  _"Astronomy On The Personal Computer"_
by O.Montenbruck, T.Phleger, Fourth Edition, Springer-Verlag, 2000.

## Contents

- [AstroScript::MathUtils](./libAstroScript::MathUtils.pm) — Core mathematical routines.
- [AstroScript::Time](./libAstroScript::Time.pm) — Time-related routines.
- [AstroScript::Ephemeris](./libAstroScript::Ephemeris.pm) — Positions of celestial bodies.
- [AstroScript::Angles](./libAstroScript::Angles.pm) — Some abstract points related to diurnal rotation of the Celestial Sphera: _Ascendant_, _Midheaven_, _Vertex_, _East Point_.
- [AstroScript::CoCo](./libAstroScript::CoCo.pm) —  Coordinates conversions.
- [AstroScript::Houses](./libAstroScript::Houses.pm) —  Astrological houses, by the most used systems.
- [AstroScript::Nutation](./libAstroScript::Nutation.pm) —  Nutation and obliquity of ecliptic.

## Requirements

* Perl >= 5.22

## Installation

To install this module, run the following commands:

```
$ perl Build.PL
$ ./Build
$ ./Build test
$ ./Build install
```

## Documentation

After installing, you can find documentation for this module with the
perldoc command from the parent directory of the library:

```
$ perldoc AstroScript
$ perldoc AstroScript::Ephemeris

```

You can also generate local HTML documentation with

```
$ perl script/createdocs.pl
```

Documentation files will be installed to **docs/** directory.

## Usage

**script/** directory contains examples of the library usage. They will be
extended over time.

To display current planetary positions, type:

```
$ perl/script/ephemeris.pl
```

For list of available options. type:

```
$ perl/script/ephemeris.pl -h
```

## Acknowledgments

There are three sources, which I used:

- O.Montenbruck, T.Phleger, _"Astronomy On The Personal Computer"_,
Fourth Edition, Springer-Verlag, 2000.
- Peter Duffett-Smith, _"Astronomy With Your Personal Computer"_,
Cambridge University Press, 1986.
- Jean Meeus, _"Astronomical Algorithms"_, Willmann-Bell, Inc., 1991.

## License And Copyright

Copyright (C) 2010-2019 Sergey Krushinsky

This program is free software; you can redistribute it and/or modify it
under the terms of the the Artistic License (1.0). You may obtain a
copy of the full license at:

https://dev.perl.org/licenses/artistic.html

Aggregation of this Package with a commercial distribution is always
permitted provided that the use of this Package is embedded; that is,
when no overt attempt is made to make this Package's interfaces visible
to the end user of the commercial distribution. Such use shall not be
construed as a distribution of this Package.

The name of the Copyright Holder may not be used to endorse or promote
products derived from this software without specific prior written
permission.

THIS PACKAGE IS PROVIDED "AS IS" AND WITHOUT ANY EXPRESS OR IMPLIED
WARRANTIES, INCLUDING, WITHOUT LIMITATION, THE IMPLIED WARRANTIES OF
MERCHANTIBILITY AND FITNESS FOR A PARTICULAR PURPOSE.
