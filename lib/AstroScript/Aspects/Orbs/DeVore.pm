package AstroScript::Aspects::Orbs::DeVore;

use strict;
use warnings;
use Readonly;

use base qw/AstroScript::Aspects::Orbs/;

Readonly::Hash our %DEFAULT_RANGES => (
    Conjunction    => [-10.0, 6.0],
    Vigintile      => [17.5, 18.5],
    Quindecile     => [23.5, 24.5],
    Semisextile    => [28.0, 31.0],
    Decile         => [35.5, 36.5],
    Sextile        => [56, 63],
    Semisquare     => [42.0, 49.0],
    Quintile       => [71.5, 72.5],
    Square         => [84.0, 96.0],
    Tridecile      => [107.5, 108.5],
    Trine          => [113.0, 125.0],
    Sesquiquadrate => [132.0, 137.0],
    Biquintile     => [143.5, 144.5],
    Quincunx       => [148.0, 151.0],
    Opposition     => [174, 186]
);


sub new {
    my $class = shift;
    my %arg = ( ranges => \%DEFAULT_RANGES, @_ );
    my $self = $class->SUPER::new( name => 'By Aspect (Nicholas deVore)');
    $self->{_ranges} = $arg{ranges};
    $self
}

sub ranges {
    $_[0]->{_ranges}
}


sub is_aspect {
    my $self = shift;
    my ($src_id, $dst_id, $aspect, $arc) = @_;
$DB::single = 1;
    my $aspname = $aspect->name;
    die "Range for $aspname does not exist" unless exists $self->ranges->{$aspname};
    my $r = $self->ranges->{$aspname};
    $r->[0] <= $arc && $r->[1] >= $arc
}


1;
__END__

=pod

=encoding UTF-8

=head1 NAME

AstroScript::Ephemeris::Aspects::Orbs::DeVore

=head1 SYNOPSIS

  use AstroScript::Ephemeris::Aspects::Orbs::DeVore;
  use AstroScript::Ephemeris::Planet qw/:ids/;

  # create object with default moieties
  my $orbs = AstroScript::Ephemeris::Aspects::Orbs::DeVore->()
  # Are Moon and Sun in conjunction, given their angular distance is 4.0 arc-degrees?
  my $b = $orbs->is_aspect($MO, $SU, $CONJUNCTION, 4); # true

=head1 DESCRIPTION

Some modern astrologers believe that orbs are based on aspects.
The values are from I<"Encyclopaedia of Astrology"> by Nicholas deVore.

=head1 METHODS

=head2 AstroScript::Aspects::Orbs::DeVore->new

AstroScript::Aspects::Orbs::DeVore->new( $ranges => hashref )
AstroScript::Aspects::Orbs::DeVore->new( $ranges => hashref )

Constructor.

=head3 Options

=over

=item * B<ranges>, hashref of C<< { ASPECT => [$min, $max]... } >>

=back

=head4 Default ranges

=over

=item * Conjunction => [-10.0, 6.0]

=item * Vigintile => [17.5, 18.5]

=item * Quindecile => [23.5, 24.5]

=item * Semisextile => [28.0, 31.0]

=item * Decile => [35.5, 36.5]

=item * Sextile => [56, 63]

=item * Semisquare => [42.0, 49.0]

=item * Quintile => [71.5, 72.5]

=item * Square => [84.0, 96.0]

=item * Tridecile => [107.5, 108.5]

=item * Trine => [113.0, 125.0]

=item * Sesquiquadrate => [132.0, 137.0]

=item * Biquintile => [143.5, 144.5]

=item * Quincunx => [148.0, 151.0]

=item * Opposition => [174, 186]

=back

=head2 $self->ranges

Getter of B<ranges> property.

=head2 $self->is_aspect($src_id, $dst_id, $aspect, $arc)

See L<description in the parent class | AstroScript::Aspects::Orbs>.

=head1 AUTHOR

Sergey Krushinsky, C<< <krushinsky at gmail.com> >>

=head1 COPYRIGHT AND LICENSE

Copyright (C) 2009-2019 by Sergey Krushinsky

This library is free software; you can redistribute it and/or modify
it under the same terms as Perl itself.

=cut
