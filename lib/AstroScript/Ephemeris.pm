
package AstroScript::Ephemeris;

use strict;
use warnings;
use Readonly;
use Module::Load;
use Exporter qw/import/;

our %EXPORT_TAGS = (
    all  => [ qw/planets planets_with_motion/ ],
);
our @EXPORT_OK = ( @{ $EXPORT_TAGS{'all'} }, );
our $VERSION = '1.00';

use Math::Trig qw/deg2rad/;
use List::Util qw/any/;
use AstroScript::Ephemeris::Planet qw/:ids/;
use AstroScript::Ephemeris::Point qw/:ids/;
use AstroScript::MathUtils qw/diff_angle/;

Readonly our $DAY_IN_CENT => 1 / 36525;

my %FUNCS;

sub _construct {
    my $id = shift;
    my $parent = shift;

    unless (exists $FUNCS{$id}) {
        my $pkg = join('::', qw/AstroScript Ephemeris/, $parent, $id);
        load $pkg;
        $FUNCS{$id} = sub {
            $pkg->new(@_);
        }
    }
    return $FUNCS{$id}
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
                x => _construct($id, 'Point')->()->position($t, %arg),
                y => 0,
                z => 0
            }
        }
        else {
            unless ($sun) {
                $sun = _construct($SU, 'Planet')->()->position($t);
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
                $pos = _construct($id, 'Planet')->()->position( $t, \%sun_lbr );
            }
        }
        [ $id, $pos ];
    };
}


sub planets {
    my $t = shift;
    my $ids_ref = shift;
    my %arg = (with_motion => 0, @_);

    my $iter_1 = _iterator($t, $ids_ref, %arg);
    return $iter_1 unless $arg{with_motion};

    my $iter_2 = _iterator($t + $DAY_IN_CENT, $ids_ref, %arg);

    return sub {
        my $res = $iter_1->() or return;
        $res->[1]->{motion} = diff_angle($res->[1]->{x}, $iter_2->()->[1]->{x});
        $res
    }
}


1;
__END__

=pod

=encoding UTF-8

=head1 NAME

AstroScript::Ephemeris - the main entry point for calculating planetary positions.

=head1 SYNOPSIS

  use DateTime;
  use AstroScript::Ephemeris::Planet qw/@PLANETS/;
  use AstroScript::Ephemeris qw/planets/;
  use Data::Dumper;

  my $jd = DateTime->now->jd; # Standard Julian date for current moment
  my $t  = ($jd - 2451545) / 36525; # Convert Julian date to centuries since epoch 2000.0
                                    # for better accuracy, $t should be converted to Ephemeris time.
  my $iter = planets( $t, \@PLANETS ); # get iterator function for Sun. Moon and the planets.

  while ( my $result = $iter->() ) {
      my ($id, $co) = @$result;
      print $id, "\n", Dumper($co), "\n"; # geocentric longitude, latitude and distance from Earth
  }

=head1 DESCRIPTION

Calculates positions of Sun, Moon, the 8 planets and Lunar Node. Algorithms are
based on I<"Astronomy on the Personal Computer"> by O.Montenbruck and Th.Pfleger,
C++ edition. The results are supposed to be precise enough for amateur's purposes.


=head1 SUBROUTINES/METHODS

=head2 planets($t, $ids, %options)

Returns iterator function, which, on its turn, returns on each pass:

=over

=item * identifier of the celestial body

=item * a hashref, containing coordinates of a celestial body and its mean daily motion

=back

=head3 Coordinates and daily motion

=over

=item * B<x> — celestial longitude, arc-degrees

=item * B<y> — celestial latitude, arc-degrees

=item * B<z> — distance from Earth in A.U.

=item * B<motion> — mean daily motion, degrees, if I<with_motion> flag is set

=back

See  the L</"SYNOPSIS">

=head3 Positional Arguments:

=over

=item * B<$t> — time in centuries since epoch 2000.0; for better precision UTC should be converted to Ephemeris time (see L<AstroScript::Time>);

=item * B<$ids> — reference to an array of ids of celestial bodies to be calculated.

=back

=head3 Named Arguments

=over

=item * B<with_motion> — optional flag; when set to I<true>, there is additional I<motion> field in the result;  B<false> by default.

=item * B<true_node> — optional flag; when set to I<true> (default), calculates I<True Lunar Node> instead of I<Mean Node> (if B<$ids> contain C<'LunarNode'>).

=back

=head1 SEE ALSO

=over

=item Oliver Montenbruck, Thomas Pfleger I<"Astronomy on the Personal Computer">, 4th edition>

=back

=head1 AUTHOR

Sergey Krushinsky, C<< <krushinsky at gmail.com> >>

=head1 COPYRIGHT AND LICENSE

Copyright (C) 2010-2019 by Sergey Krushinsky

This library is free software; you can redistribute it and/or modify
it under the same terms as Perl itself.

=cut
