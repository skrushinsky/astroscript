package AstroScript::Aspects::Orbs::AspectRatio;

use strict;
use warnings;
use Readonly;

use AstroScript::Aspects::Constants qw/:types/;
use AstroScript::Aspects::Orbs::Dariot;

use base qw/AstroScript::Aspects::Orbs/;

sub new {
    my $class = shift;
    my %arg = (
        minor_coeff  => 0.6,
        kepler_coeff => 0.4,
        moieties       => \%AstroScript::Aspects::Orbs::Dariot::DEFAULT_MOIETIES,
        default_moiety => 4,
        @_
    );
    my $self = $class->SUPER::new( name => 'Classic with regard to Aspect type');
    $self->{_minor_coeff} = $arg{minor_coeff};
    $self->{_kepler_coeff} = $arg{kepler_coeff};
    $self->{_classic} = AstroScript::Aspects::Orbs::Dariot->new(
        moieties       => $arg{moieties},
        default_moiety => $arg{default_moiety}
    );
    $self
}

sub minor_coeff {
    $_[0]->{_minor_coeff}
}

sub kepler_coeff {
    $_[0]->{_kepler_coeff}
}

sub is_aspect {
    my $self = shift;
    my ($src_id, $dst_id, $aspect, $arc) = @_;

    my $orb = $self->{_classic}->calculate_orb($src_id, $dst_id);
    if ($aspect->type == $MINOR) {
        $orb *= $self->minor_coeff;
    } elsif ($aspect->type == $KEPLER) {
        $orb *= $self->major_coeff;
    }
    my $delta = abs($arc - $aspect->value);
    $delta <= $orb
}


1;
__END__

=pod

=encoding UTF-8

=head1 NAME

AstroScript::Ephemeris::Aspects::Orbs::AspectRatio

=head1 SYNOPSIS

  use AstroScript::Ephemeris::Aspects::Orbs::AspectRatio;
  use AstroScript::Ephemeris::Planet qw/:ids/;

  my $orbs = AstroScript::Ephemeris::Aspects::Orbs::AspectRatio->()
  # Are Moon and Sun in conjunction, given their angular distance is 4.0 arc-degrees?
  my $b = $orbs->is_aspect($MO, $SU, $CONJUNCTION, 4); # true

=head1 DESCRIPTION

Combined approach. For major aspects classic (I<Dariot>) method is applied.
For minor and kepler aspects we apply to the classic orb value a
special coefficient: by default, 0.6 (60%) for minor and 0.4 (40%) for Keplerian.

=head2 AstroScript::Aspects::Orbs::AspectRatio->new

  AstroScript::Aspects::Orbs::AspectRatio->new()
  AstroScript::Aspects::Orbs::AspectRatio->new(%options)

Constructor.

=head3 Options

=over

=item * B<moieties>, hashref, see L<AstroScript::Ephemeris::Aspects::Orbs::Dariot>

=item * B<default_moiety>, number, , see L<AstroScript::Ephemeris::Aspects::Orbs::Dariot>

=item * B<minor_coeff>, coefficient for Minor aspects. Default: B<0.6>.

=item * B<minor_coeff>, coefficient for Kepler aspects. Default: B<0.4>.

=back

=head2 $self->minor_coeff

Getter of B<minor_coeff> property.

=head2 $self->kepler_coeff

Getter of B<kepler_coeff> property.

=head2 $self->is_aspect($src_id, $dst_id, $aspect, $arc)

See L<description in the parent class | AstroScript::Aspects::Orbs>.

=head1 SEE ALSO

L<AstroScript::Ephemeris::Aspects::Orbs::Dariot>

=head1 AUTHOR

Sergey Krushinsky, C<< <krushinsky at gmail.com> >>

=head1 COPYRIGHT AND LICENSE

Copyright (C) 2009-2019 by Sergey Krushinsky

This library is free software; you can redistribute it and/or modify
it under the same terms as Perl itself.

=cut
