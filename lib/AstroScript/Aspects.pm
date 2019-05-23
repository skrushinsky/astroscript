package AstroScript::Aspects;

use strict;
use warnings;


use Exporter qw/import/;
use Readonly;
use Module::Load;
use Memoize;
memoize('_create_orbs_method');

use AstroScript::Aspects::Aspect;
use AstroScript::Aspects::Constants qw/:types :influences/;
use AstroScript::Ephemeris::Planet qw/@PLANETS/;
use AstroScript::MathUtils qw/angle_c diff_angle/;

our $VERSION = '1.00';

Readonly our $CONJUNCTION => AstroScript::Aspects::Aspect->new(
    name       => 'Conjunction',
    brief_name => 'cnj',
    value      => 0,
    influence  => $NEUTRAL,
    type       => $MAJOR
);

Readonly our $VIGINTILE => AstroScript::Aspects::Aspect->new(
    name       => 'Vigintile',
    brief_name => 'vgt',
    value      => 18,
    influence  => $CREATIVE,
    type       => $KEPLER
);

Readonly our $QUINDECILE => AstroScript::Aspects::Aspect->new(
    name       => 'Quindecile',
    brief_name => 'qdc',
    value      => 24,
    influence  => $CREATIVE,
    type       => $KEPLER
);

Readonly our $SEMISEXTILE => AstroScript::Aspects::Aspect->new(
    name       => 'Quindecile',
    brief_name => 'ssx',
    value      => 30,
    influence  => $POSITIVE,
    type       => $MINOR
);

Readonly our $DECILE => AstroScript::Aspects::Aspect->new(
    name       => 'Decile',
    brief_name => 'dcl',
    value      => 36,
    influence  => $CREATIVE,
    type       => $KEPLER
);

Readonly our $SEXTILE => AstroScript::Aspects::Aspect->new(
    name       => 'Sextile',
    brief_name => 'sxt',
    value      => 60,
    influence  => $POSITIVE,
    type       => $MAJOR
);

Readonly our $SEMISQUARE => AstroScript::Aspects::Aspect->new(
    name       => 'Semisquare',
    brief_name => 'ssq',
    value      => 45,
    influence  => $NEGATIVE,
    type       => $MINOR
);

Readonly our $QUINTILE => AstroScript::Aspects::Aspect->new(
    name       => 'Quintile',
    brief_name => 'qui',
    value      => 72,
    influence  => $CREATIVE,
    type       => $KEPLER
);

Readonly our $SQUARE => AstroScript::Aspects::Aspect->new(
    name       => 'Square',
    brief_name => 'sqr',
    value      => 90,
    influence  => $NEGATIVE,
    type       => $MAJOR
);

Readonly our $TRIDECILE => AstroScript::Aspects::Aspect->new(
    name       => 'Quindecile',
    brief_name => 'tdc',
    value      => 108,
    influence  => $POSITIVE,
    type       => $MINOR
);

Readonly our $TRINE => AstroScript::Aspects::Aspect->new(
    name       => 'Trine',
    brief_name => 'tri',
    value      => 120,
    influence  => $POSITIVE,
    type       => $MAJOR
);

Readonly our $SESQUIQUADRATE => AstroScript::Aspects::Aspect->new(
    name       => 'Sesquiquadrate',
    brief_name => 'sqq',
    value      => 135,
    influence  => $NEGATIVE,
    type       => $MINOR
);

Readonly our $BIQUINTILE => AstroScript::Aspects::Aspect->new(
    name       => 'Quintile',
    brief_name => 'bqu',
    value      => 144,
    influence  => $CREATIVE,
    type       => $KEPLER
);

Readonly our $QUINCUNX => AstroScript::Aspects::Aspect->new(
    name       => 'Quincunx',
    brief_name => 'qcx',
    value      => 150,
    influence  => $NEGATIVE,
    type       => $MINOR
);

Readonly our $OPPOSITION => AstroScript::Aspects::Aspect->new(
    name       => 'Opposition',
    brief_name => 'sqr',
    value      => 180,
    influence  => $NEGATIVE,
    type       => $MAJOR
);


Readonly::Array our @ASPECTS => (
    $CONJUNCTION, $VIGINTILE, $QUINDECILE, $SEMISEXTILE,
    $DECILE, $SEXTILE, $SEMISQUARE, $QUINTILE, $SQUARE, $TRIDECILE,
    $TRINE, $SESQUIQUADRATE, $BIQUINTILE, $QUINCUNX, $OPPOSITION
);

our %EXPORT_TAGS = (
    aspects => \@ASPECTS,
);

our @EXPORT_OK = (
    @{ $EXPORT_TAGS{'aspects'} }, '@ASPECTS'
);


Readonly our $DEFAULT_ORBS_FUNC => 'AspectRatio';
Readonly our $DEFAULT_TYPE_FLAGS => $MAJOR;
Readonly our $DEFAULT_GAP => 10.0;

# Factory function that returns constructor of a given method for calculating orbs.
# It does not call the constructor.
sub _create_orbs_method {
    my $name = shift;
    my $pkg = join('::', qw/AstroScript Aspects Orbs/, $name);
    load $pkg;
    sub { $pkg->new(@_) }
}

sub new {
    my $class = shift;
    my %arg = (
        orbs_func_name => $DEFAULT_ORBS_FUNC,
        orbs_func_args => [],
        type_flags     => $DEFAULT_TYPE_FLAGS,
        @_
    );

    my $orbs_method = _create_orbs_method(
        $arg{orbs_func_name})->(@{$arg{orbs_func_args}}
    );

    bless  {
        _orbs_func  => sub { $orbs_method->is_aspect(@_) },
        _type_flags => $arg{type_flags},
        _aspects    => [ grep { $arg{type_flags} & $_->type } @ASPECTS ]
    }, $class
}


sub aspects {
    $_[0]->{_aspects}
}

sub is_aspect {
    my $self = shift;
    $self->{_orbs_func}->(@_)
}

sub type_flags {
    $_[0]->{_type_flags}
}


sub find_closest {
    my $self = shift;
    my ($src, $dst, $arc) = @_;

    my @candidates = sort {
        $b->[1] <=> $a->[1]
    } map {
        [ $_, abs($_->value - $arc) ]
    } grep {
        $self->is_aspect($src, $dst, $_, $arc)
    } @{$self->aspects};

    @candidates ? $candidates[0] : undef
}

sub iterator {
    my $self = shift;
    my ($src, $targets) = @_;
    my @t = @$targets;
    sub {
    NEXT:
        my $dst = shift @t or return;
        my $arc = angle_c($src->{x}, $dst->{x});
        my $res = $self->find_closest($src->{id}, $dst->{id}, $arc) or goto NEXT;
        {
            target => $dst->{id},
            aspect => $res->[0],
            arc    => $arc,
            delta  => $res->[1]
        }
    }
}

sub find_aspects_to {
    my $self = shift;
    my ($from, $targets, $callback) = @_;
    my $iter = $self->iterator($from, $targets);
    while (my $res = $iter->()) {
        $callback->($res)
    }
}


sub partition {
    my $class = shift;
    my $positions = shift;
    my %arg = (gap => $DEFAULT_GAP, callback => undef, @_);

    my @sorted = sort { $a->{x} <=> $b->{x} } @$positions;
    my @group;
    for (my $i = 0; $i <= $#sorted; $i++) {
        my $curr = $sorted[$i];
        push @group, $curr->{id};
        if ($i < $#sorted) {
            my $next = $sorted[$i+1];
            if (diff_angle($curr->{x}, $next->{x}) > $arg{gap}) {
                $arg{callback}->(@group);
                @group = ();
            }
        } else {
            $arg{callback}->(@group);
        }
    }
}


1;

__END__

=pod

=encoding UTF-8

=head1 NAME

AstroScript::Aspects - main class for calculating aspects.

=head1 SYNOPSIS

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


=head1 DESCRIPTION

Main class for determining aspects. Instance of this class holds some settings,
which must be known before doing calculations:

=over

=item *

type of orbs;

=item * which aspects we are interested in

=back

See the L<< Constructor|METHODS/AstroScript::Aspects->new( %options ) >> named arguments.

=head1 EXPORTED CONSTANTS

=head2 Aspects

All the constants are instances of L<AstroScript::Aspects::Aspect> class. To
import them, use C<:aspects> tag: C<use AstroScript::Aspects qw/:aspects/;>

=over

=item * $CONJUNCTION

=item * $VIGINTILE

=item * $QUINDECILE

=item * $SEMISEXTILE

=item * $DECILE

=item * $SEXTILE

=item * $SEMISQUARE

=item * $QUINTILE

=item * $SQUARE

=item * $TRIDECILE

=item * $TRINE

=item * $SESQUIQUADRATE

=item * $BIQUINTILE

=item * $QUINCUNX

=item * $OPPOSITION

=back


=head2 Miscellaneous

=over

=item * C<@ASPECTS> — array containing all of the aspects listed above. To import: C<use AstroScript::Aspects qw /@ASPECTS/;>

=back

=head1 METHODS

=head2 AstroScript::Aspects->new( %options )

Constructor.

=head3 Named arguments:

=over

=item B<orbs> — instance of L<AstroScript::Aspects::Orbs> class. L<AstroScript::Aspects::Orbs::AspectRatio> by default.

=item B<type_flags> — combination of C<$MAJOR>, C<$MINOR> and C<$KEPLER> flags. C<$MAJOR> by default.

=back

=head2 $self->orbs

Readonly accessor. Returns instance of L<AstroScript::Aspects::Orbs> class.

=head2 $self->type_flags

Readonly accessor. Returns integer, which is combination of C<$MAJOR>, C<$MINOR>
and C<$KEPLER> flags, which are exported by L<AstroScript::Aspects::Constants>
module.

  use AstroScript::Aspects;
  use AstroScript::Aspects::Constants qw/:types/;

  my $aspects = AstroScript::Aspects->new(type_flags => ($MAJOR | $MINOR | $KEPLER))

  my $flags = $aspects->type_flags;
  say "Major aspects are used" if $flags & $MAJOR;
  say "Minor aspects are used" if $flags & $MINOR;
  say "Kepler aspects are used" if $flags & $KEPLER;

=head2 $self->aspects

Readonly accessor. Returns arrayref to aspects taken into account. Each element
is an instance of L<AstroScript::Aspects::Aspect> class. Content of the array is
determimned by B<type_flags> L<< constructor|AstroScript::Aspects->new( %options ) >> option.

=head2 $self->find_closest($src, $dst, $arc)

Given two planetary positions, find closest aspect between them. Only those
aspects are taken into account, which are returned by L<< $self->aspects >> accessor.

=head3 Arguments

=over

=item * $src: planet id, string

=item * $dst: planet id, string

=item * $arc: distance in arc-degrees

=back

=head3 Returns

Closest aspect, instance of L<AstroScript::Aspects::Aspect> class, or C<undef>
if there are no aspects between the bodies.

=head2 $self->iterator($src, $targets)

Given a planetary position, search its aspects to other planets. Iterator interface.

=head3 Arguments

=over

=item * $src: hash of C<< { x => longitude in degrees, id => planet identifier } >>

=item * $targets: reference to array of other bodies, each element represented by a hash similar to B<$src> argument

=back

=head3 Returns

An iterator function. Each call to it returns a hash of:

=over

=item * B<target>: id of aspected planet (string)

=item * B<aspect>: L<AstroScript::Aspects::Aspect> instance

=item * B<arc>: angular distance between planets (arc-degrees)

=item * B<delta>: difference between actual distance and exact aspect value

=back

When aspects are exhausted, the function returns C<undef>.

=head3 Example

  my $iter = $aspects->iterator($src, \@targets);
  while (my $res = $iter->()) {
      print Dumper($res);
  }


=head2 $self->find_aspects_to($src, $targets, $callback)

Given a planetary position, search its aspects to other planets. Callback interface.

=head3 Arguments

=over

=item * B<$src>: hash of C<< { x => longitude in degrees, id => planet identifier } >>

=item * B<$targets>: reference to array of other bodies, each element represented by a hash similar to B<$src> argument

=item * B<$callback>: callback function, called each time an aspect is found with hash similar to that, which is returned by the iterator.

=back

=head2 AstroScript::Aspects->partition($positions, $callback)

Class method. Given array of planetary positions, yield each stellium or a single
planet in case that there are no other planets closer than the gap.

=head3 Arguments

=over

=item * B<$positions>: arrayref of planetary positions: C<< [{ id => string, x => degrees }...] >>

=back

=head3 Named Arguments

=over

=item * B<gap> minimal distance between groups (opional, I<10°> by default).

=item * B<callback> callback function, required. It is called each time a new group is "closed", arguments are ids of the group members.

=back

=head3 Example

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

=head1 SEE ALSO

=over

=item * L<AstroScript::Aspects::Aspect>

=item * L<AstroScript::Aspects::Constants>

=item * L<AstroScript::Aspects::Orbs>

=back

=head1 AUTHOR

Sergey Krushinsky, C<< <krushinsky at gmail.com> >>

=head1 COPYRIGHT AND LICENSE

Copyright (C) 2009-2019 by Sergey Krushinsky

This library is free software; you can redistribute it and/or modify
it under the same terms as Perl itself.

=cut
