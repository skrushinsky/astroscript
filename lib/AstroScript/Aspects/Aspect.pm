package AstroScript::Aspects::Aspect;

use strict;
use warnings;

sub new {
    my $class = shift;
    my %arg = @_;
    my %props = map { ("_$_", $arg{$_}) } qw/name brief_name value influence type/;
    bless \%props, $class;
}

sub name { $_[0]->{_name} }

sub brief_name { $_[0]->{_brief_name} }

sub value { $_[0]->{_value} }

sub influence { $_[0]->{_influence} }

sub type { $_[0]->{_type} }

1;

__END__

=pod

=encoding UTF-8

=head1 NAME

AstroScript::Aspects::Aspect - Base class for an aspect.

=head1 SYNOPSIS

  package AstroScript::Aspects::Aspect::Mercury;
  use base qw/AstroScript::Aspects::Aspect/;
  ...

  sub  heliocentric {
    # implement the method
  }


=head1 DESCRIPTION

Base class for an aspect. In most cases there is no need to use this class,
unless you wich to use some rare experimental aspect. All the standard aspects
are created and exported by L<AstroScript::Aspects> module.


=head1 METHODS

=head2 AstroScript::Aspects::Aspect->new( %options )

Constructor.

=head3 Named arguments:

=over

=item *

B<name> — the name

=item *

B<brief_name> — 3-letters identificator for tables

=item *

B<value> — arc-distance in degrees, e.g. 120 for I<trine>.

=item *

B<influence> — one of constants exported by L<AstroScript::Aspects::Constants>:
C<$POSITIVE>, C<$NEGATIVE>, C<$NEUTRAL>, C<$CREATIVE>.

=item *

B<type> — one of constants exported by L<AstroScript::Aspects::Constants>:
C<$MAJOR>, C<$MINOR>, C<$KEPLER>.


=back


=head2 $self->name

Read-only accessor for aspect's name

=head2 $self->brief_name

Read-only accessor for  3-letters identificator

=head2 $self->value

arc-distance in degrees

=head2 $self->influence

one of constants exported by L<AstroScript::Aspects::Constants>:
C<$POSITIVE>, C<$NEGATIVE>, C<$NEUTRAL>, C<$CREATIVE>.

=head2 $self->type

one of constants exported by L<AstroScript::Aspects::Constants>:
C<$MAJOR>, C<$MINOR>, C<$KEPLER>.

=head1 AUTHOR

Sergey Krushinsky, C<< <krushinsky at gmail.com> >>

=head1 COPYRIGHT AND LICENSE

Copyright (C) 2009-2019 by Sergey Krushinsky

This library is free software; you can redistribute it and/or modify
it under the same terms as Perl itself.

=cut
