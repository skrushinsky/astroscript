
package AstroScript::Ephemeris;

use strict;
use warnings;
use Readonly;
use Module::Load;
use Memoize;
memoize qw/_create_constructor/;

use Exporter qw/import/;

our %EXPORT_TAGS = (
    all  => [ qw/iterator find_positions/ ],
);
our @EXPORT_OK = ( @{ $EXPORT_TAGS{'all'} }, );
our $VERSION = '1.10';

use Math::Trig qw/deg2rad/;
use List::Util qw/any/;
use AstroScript::Ephemeris::Planet qw/:ids/;
use AstroScript::Ephemeris::Point qw/:ids/;
use AstroScript::MathUtils qw/diff_angle/;

Readonly our $DAY_IN_CENT => 1 / 36525;

# Factory function. Loads given class and returns function that wraps
# its constructor.
#
# Example:
# my $f = _create_constructor('AstroScript::Ephemeris::Planets::Sun');
# my $sun = $f->(); # instantiate the object
# my $pos = $sun->position($t); # calculate coordinates for the moment $t
sub _create_constructor {
    my $pkg = shift;
    load $pkg;
    sub { $pkg->new(@_) }
}

# shortcut for _create_constructor
sub _construct {
    _create_constructor(join('::', qw/AstroScript Ephemeris/, @_))
}


sub _iterator {
    my $t = shift;
    my $ids_ref = shift;
    my @items = @{$ids_ref};
    my %arg = @_;
    my $sun;
    my %sun_lbr;

    return sub {
    NEXT:
        return unless @items;  # no more items, stop iteration

        my $id = shift @items;
        my $pos;
        if ( $id eq $LN ) {
            $pos = {
                x => _construct('Point', $id)->()->position($t, %arg),
                y => 0,
                z => 0
            }
        }
        else {
            unless ($sun) {
                $sun = _construct('Planet', $SU)->()->position($t);
                %sun_lbr = (
                    l => deg2rad($sun->{x}),
                    b => deg2rad($sun->{y}),
                    r => $sun->{z}
                );
            }
            if ( $id eq $SU ) {
                $pos = $sun;
            }
            else {
                if ($id eq $PL ) {
                    if ($t < -1.1 || $t > 1.0) {
                        goto NEXT;
                    }
                }
                $pos = _construct('Planet', $id)->()->position( $t, \%sun_lbr );
            }
        }
        [ $id, $pos ];
    };
}


sub iterator {
    my $t       = shift;
    my $ids_ref = shift;
    my %arg     = (with_motion => 0, @_);

    my $iter_1 = _iterator($t, $ids_ref, %arg);
    return $iter_1 unless $arg{with_motion};

    my $iter_2 = _iterator($t + $DAY_IN_CENT, $ids_ref, %arg);

    return sub {
        my $res = $iter_1->() or return;
        $res->[1]->{motion} = diff_angle($res->[1]->{x}, $iter_2->()->[1]->{x});
        $res
    }
}

sub find_positions {
    my $t        = shift;
    my $ids_ref  = shift;
    my $callback = shift;

    my $iter = iterator($t, $ids_ref, @_);
    while ( my $res = $iter->() ) {
        my ($id, $pos) = @$res;
        $callback->($id, %$pos);
    }
}


1;
__END__

=pod

=encoding UTF-8

=head1 NAME

AstroScript::Ephemeris - the main entry point for calculating planetary positions.

=head1 SYNOPSIS

=head2 Iterator interface

  use AstroScript::Ephemeris::Planet qw/@PLANETS/;
  use AstroScript::Ephemeris qw/iterator/;
  use Data::Dumper;

  my $jd = 2458630.5; # Standard Julian date for May 27, 2019, 00:00 UTC.
  my $t  = ($jd - 2451545) / 36525; # Convert Julian date to centuries since epoch 2000.0
                                    # for better accuracy, convert $t to Ephemeris (Dynamic).
  my $iter = iterator( $t, \@PLANETS ); # get iterator function for Sun. Moon and the planets.

  while ( my $result = $iter->() ) {
      my ($id, $co) = @$result;
      print $id, "\n", Dumper($co), "\n"; # geocentric longitude, latitude and distance from Earth
  }

=head2 Callback interface

  use AstroScript::Ephemeris::Planet qw/@PLANETS/;
  use AstroScript::Ephemeris qw/find_positions/;

  my $jd = 2458630.5; # Standard Julian date for May 27, 2019, 00:00 UTC.
  my $t  = ($jd - 2451545) / 36525; # Convert Julian date to centuries since epoch 2000.0
                                    # for better accuracy, convert $t to Ephemeris (Dynamic) time.

  find_positions($t, \@PLANETS, sub {
      my ($id, %pos) = @_;
      say "$id X: $pos{x}, Y: $pos{y}, Z: $pos{z}";
  })


=head1 DESCRIPTION

Calculates positions of Sun, Moon, the 8 planets and Lunar Node. Algorithms are
based on I<"Astronomy on the Personal Computer"> by O.Montenbruck and Th.Pfleger,
C++ edition. The results are supposed to be precise enough for amateur's purposes.

You may use one of two interfaces: iterator and callback.

=head2 Notes on implementation

This module is implemented as a "factory". User may not need all the planets and
points at once, so each class is loaded lazily, by demand. Over time, the range
of celestial objects may be extended.


=head2 Mean daily motion

To calculate mean daily motion along with the celestial coordinates, use C<with_motion>
option:

  iterator( $t, \@PLANETS, with_motion => 1 );
  # Or:
  find_positions($t, \@PLANETS, $callback, with_motion => 1);


=head2 Lunar node

To calculate Lunar Node position, include $LN constant (C<'LunarNode'>) to the
array of celestial bodies ids:

  use AstroScript::Ephemeris::Planet qw/@PLANETS/;
  use AstroScript::Ephemeris::Point qw/$LN/;

  my @objects = (@PLANETS, $LN);

  iterator( $t, @\objects, %options);
  # Or:
  find_positions($t, \@objects, $callback, %options);

By default, the program returns position of I<True Lunar Node>. To calculate
the I<Mean Node>, use C<true_node> option:

  iterator( $t, @\objects, true_node => 0);
  # Or:
  find_positions($t, \@objects, true_node => 0);

=head2 Pluto

Pluto's position is calculated only between years B<1890> and B<2100>.
See L<AstroScript::Ephemeris::Planet::Pluto>.


=head1 SUBROUTINES

=head2 iterator($t, $ids, %options)

Returns iterator function, which, on its turn, when called returns either C<undef>,
when exhausted, or arrayref, containing:

=over

=item * identifier of the celestial body, a string

=item * a hashref, containing celestial coordinates and mean daily motion

=back

=head3 Coordinates and daily motion

=over

=item * B<x> — celestial longitude, arc-degrees

=item * B<y> — celestial latitude, arc-degrees

=item * B<z> — distance from Earth in A.U.

=item * B<motion> — mean daily motion, degrees, (only when I<with_motion> flag is set)

=back

=head3 Positional Arguments

=over

=item *

B<$t> — time in centuries since epoch 2000.0; for better precision UTC should be
converted to Ephemeris time (see L<AstroScript::Time>);

=item *

B<$ids> — reference to an array of ids of celestial bodies to be calculated.

=back

=head3 Named Arguments

=over

=item *

B<with_motion> — optional flag; when set to I<true>, there is additional I<motion>
field in the result;  B<false> by default.

=item *

B<true_node> — optional flag; when set to I<true> (default), calculates
I<True Lunar Node> instead of I<Mean Node> (if B<$ids> contain C<'LunarNode'>).

=back

=head2 find_position($t, $ids, $callback, %options)

The arguments are the same as for the L<iterator|/iterator($t, $ids, %options)>,
except the third, which is a B<callback function>. It is called on each iteration:

  $callback->($id, x => $scalar, y => $scalar, z => $scalar [, motion => $scalar])

The arguments are the same as described L<above|/Coordinates and daily motion>.

=head1 SEE ALSO

=over

=item *

Oliver Montenbruck, Thomas Pfleger I<"Astronomy on the Personal Computer">,
4th edition>

=back

=head1 AUTHOR

Sergey Krushinsky, C<< <krushinsky at gmail.com> >>

=head1 COPYRIGHT AND LICENSE

Copyright (C) 2010-2019 by Sergey Krushinsky

This library is free software; you can redistribute it and/or modify
it under the same terms as Perl itself.

=cut
