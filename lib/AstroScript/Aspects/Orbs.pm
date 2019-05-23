package AstroScript::Aspects::Orbs;

use strict;
use warnings;


sub new {
    my $class = shift;
    my %arg = @_;

    bless {
        _name => $arg{name},
    }, $class
}


sub name {
    $_[0]->{_name}
}

sub is_aspect { die "Must be implemented by $_[0]" }


1;
__END__

=pod

=encoding UTF-8

=head1 NAME

AstroScript::Aspects::Orbs - Base class for calculating orbs. Each descendant
must implement C<is_aspect> method.

=head1 SYNOPSIS

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
      ... # check aspect, then return true or false
  }


=head1 DESCRIPTION

AstroScript::Aspects::Orbs - Base class for calculating orbs. Each descendant
must implement C<is_aspect> method.

=head1 METHODS

=head2 AstroScript::Aspects::Orbs->new( name => str )

Constructor. B<$name> is the unique system name.

=head2 $self->name

Getter of B<name> property.

=head2 $self->is_aspect($src_id, $dst_id, $aspect, $arc)

Are two bodies in given aspect?

=head3 Arguments

=over

=item * B<$src_id> — identifier of the first celestial body, string

=item * B<$src_id> — identifier of the second celestial body, string

=item * B<$aspect> — instance of L<AstroScript::Aspects::Aspect> class.

=item * B<$arc> — angular distance between the two bodies in degrees.

=back

=head3 Return

I<true> if there is the two bodies are in given aspect, otherwise I<false>.

=head1 AUTHOR

Sergey Krushinsky, C<< <krushinsky at gmail.com> >>

=head1 COPYRIGHT AND LICENSE

Copyright (C) 2009-2019 by Sergey Krushinsky

This library is free software; you can redistribute it and/or modify
it under the same terms as Perl itself.

=cut
