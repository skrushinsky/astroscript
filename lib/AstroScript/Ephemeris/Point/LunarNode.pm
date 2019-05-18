package AstroScript::Ephemeris::Point::LunarNode;

use strict;
use warnings;

use Math::Trig qw/:pi rad2deg deg2rad/;
use AstroScript::Ephemeris::Planet;
use base qw/AstroScript::Ephemeris::Point/;
use AstroScript::Ephemeris::Point qw/$LN/;
use AstroScript::MathUtils qw /reduce_deg polynome/;
use Readonly;

our $VERSION = '1.00';

Readonly my $MOO_ORBIT => {
    # Mean longitude
    L => [218.3164477, 481267.88123421, -0.0015786, 1.0/538841, -(1.0/65194000)],
    # Mean elongation
    D => [297.8501921, 445267.1114034, -0.0018819, 1.0/545868, -(1.0/113065000)],
    # Mean anomaly
    M => [134.9633964, 477198.8675055, 0.0087414, 1.0/69699, -(1.0/14712000)],
    # Argument of latitude (mean distance of the Moon from its ascending node)
    F => [93.272095, 483202.0175233, -0.0036539, -(1.0/3526000), 1.0/863310000],
};

Readonly my $SUN_ORBIT => {
    # Mean anomaly
    M => [357.5291092, 35999.0502909, -0.0001536, 1.0/24490000]
};

Readonly::Array my @TERMS => (
    125.0445479, -1934.1362891, 0.0020754, 1.0/467441, 1.0/60616000
);


sub new {
    my $class = shift;
    $class->SUPER::new( id => $LN );
}


sub position {
    my $self = shift;
    my $t = shift;
    my %arg = ( true_node => 1, @_ );

    my $mn = polynome($t, @TERMS);
    if ($arg{true_node}) {
        my ($d, $m, $f) = map {
            deg2rad(reduce_deg(polynome( $t, @{ $MOO_ORBIT->{$_} } )))
        } qw/D M F/;
        my $ms = deg2rad(reduce_deg(polynome( $t, @{ $SUN_ORBIT->{M} } )));
        $mn -= 1.4979 * sin(2 * ($d - $f))
            - 0.1500 * sin($ms)
            - 0.1226 * sin(2 * $d)
            + 0.1176 * sin(2 * $f)
            - 0.0801 * sin(2 * ($m - $f));
    }

    reduce_deg($mn)
}


1;

__END__

=pod

=encoding UTF-8

=head1 NAME

AstroScript::Ephemeris::Point::Node - Lunar Node

=head1 SYNOPSIS

  use AstroScript::Ephemeris::Point::Node;
  my $node = AstroScript::Ephemeris::Point::Node->new();
  my $pos = $node->position($t); # ecliptical coordinates

=head1 DESCRIPTION

Child class of L<AstroScript::Ephemeris::Point>, responsible for calculating
B<True Lunar Node> position.

=head1 METHODS

=head2 AstroScript::Ephemeris::Point::LunarNode->new

Constructor.

=head2 position($t, %options)

Given $t, Julian days from epoch 2000.0, in centuries, return ecliptic longitude.

=head1 AUTHOR

Sergey Krushinsky, C<< <krushinsky at gmail.com> >>

=head1 COPYRIGHT AND LICENSE

Copyright (C) 2009-2019 by Sergey Krushinsky

This library is free software; you can redistribute it and/or modify
it under the same terms as Perl itself.

=cut
