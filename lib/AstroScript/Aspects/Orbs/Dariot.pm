package AstroScript::Aspects::Orbs::Dariot;

use strict;
use warnings;
use Readonly;

use AstroScript::Ephemeris::Planet qw/:ids/;

Readonly::Hash our %DEFAULT_MOIETIES => (
    $MO =>  12.0,
    $SU =>  15.0,
    $ME =>  7.0,
    $VE =>  7.0,
    $MA =>  8.0,
    $JU =>  9.0,
    $SA =>  9.0,
    $UR =>  6.0,
    $NE =>  6.0,
    $PL =>  5.0
);

use base qw/AstroScript::Aspects::Orbs/;



sub new {
    my $class = shift;
    my %arg = (
        moieties       => \%DEFAULT_MOIETIES,
        default_moiety => 4,
        @_
    );
    my $self = $class->SUPER::new( name => 'Classic (Claude Dariot)');
    $self->{_moieties} = $arg{moieties};
    $self->{_default_moiety} = $arg{default_moiety};
    $self;
}

sub moieties {
    $_[0]->{_moieties}
}

sub default_moiety {
    $_[0]->{_default_moiety}
}

sub moiety {
    my $self = shift;
    my ( $planet_id ) = @_;
    exists $self->{_moieties}->{$planet_id} ? $self->moieties->{$planet_id}
                                            : $self->default_moiety;
}

sub calculate_orb {
    my $self = shift;
    my ($src_id, $dst_id) = @_;
    # Calculate mean orb for the two planets
    my $a = $self->moiety($src_id);
    my $b = $self->moiety($dst_id);
    ($a + $b) / 2
}

sub is_aspect {
    my $self = shift;
    my ($src_id, $dst_id, $aspect, $arc) = @_;
    my $delta = abs($arc - $aspect->value);
    my $orb = $self->calculate_orb($src_id, $dst_id);
    $delta <= $orb;
}


1;
__END__

=pod

=encoding UTF-8

=head1 NAME

AstroScript::Ephemeris::Aspects::Orbs::Dariot

=head1 SYNOPSIS

  use AstroScript::Ephemeris::Aspects::Orbs::Dariot;
  use AstroScript::Ephemeris::Planet qw/:ids/;

  my $orbs = AstroScript::Ephemeris::Aspects::Orbs::Dariot->new()
  # Are Moon and Sun in conjunction, given their angular distance is 4.0 arc-degrees?
  my $b = $orbs->is_aspect($MO, $SU, $CONJUNCTION, 4); # true

=head1 DESCRIPTION

I<Claude Dariot> (1533-1594), introduced the so called I<'moieties'> (mean-values)
when calculating orbs. According to Dariot, Mercury and the Moon enter completion
(application) of any aspect at a  distance of 9½° degrees - the total of their
respective moieties (Mercury = 3½° + Moon = 6°). This method became the standard
for European Renaissance astrologers.

The method does not take into account the nature of aspects.

=head1 METHODS

=head2 AstroScript::Aspects::Orbs::Dariot->new

AstroScript::Aspects::Orbs::Dariot->new()
AstroScript::Aspects::Orbs::Dariot->new(moieties => hashref, default_moiety => scalar)

Constructor.

=head3 Options

=over

=item * B<moieties>, hashref of C<< { PLANET_ID => $value... } >>

=item * B<default_moiety>, number, used if a body id not in L</moieties> hash. Default: B<4>.

=back

=head4 Default moieties

=over

=item * C<$MO> =>  12.0

=item * C<$SU> =>  15.0

=item * C<$ME> =>  7.0

=item * C<$VE> =>  7.0

=item * C<$MA> =>  8.0

=item * C<$JU> =>  9.0

=item * C<$SA> =>  9.0

=item * C<$UR> =>  6.0

=item * C<$NE> =>  6.0

=item * C<$PL> =>  5.0

=back

=head2 $self->moieties

Getter of B<moieties> property.

=head2 $self->default_moiety

Getter of B<default_moiety> property.

=head2 $self->moiety($planet_id)

Return moiety for given celestial body, or L<< /$self->default_moiety >>, if the body
is not registered in  L<< /$self->default_moieties >>.

=head2 $self->calculate_orb($src_id, $dst_id)

Calculate orb between celestial bodies B<$src_id> and B<$dst_id>.

=head2 $self->is_aspect($src_id, $dst_id, $aspect, $arc)

See L<description in the parent class | AstroScript::Aspects::Orbs>.

=head1 SEE ALSO

=over

=item * AstroScript::Aspects

=item * AstroScript::Aspects::Orbs

=back

=head1 AUTHOR

Sergey Krushinsky, C<< <krushinsky at gmail.com> >>

=head1 COPYRIGHT AND LICENSE

Copyright (C) 2009-2019 by Sergey Krushinsky

This library is free software; you can redistribute it and/or modify
it under the same terms as Perl itself.

=cut
