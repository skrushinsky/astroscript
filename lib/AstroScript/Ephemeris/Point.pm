package AstroScript::Ephemeris::Point;
use strict;
use warnings;

use Readonly;

our $VERSION = '0.01';

Readonly our $LN => 'LunarNode';
Readonly our $AS => 'Ascendant';
Readonly our $MC => 'Midheaven';
Readonly our $VX => 'Vertex';
Readonly our $EP => 'EastPoint';

Readonly::Array our @POINTS => ( $LN, $AS, $MC, $VX, $EP );


use Exporter qw/import/;

our %EXPORT_TAGS = ( ids => [qw/$LN $AS $MC $VX $EP/], );

our @EXPORT_OK = ( @{ $EXPORT_TAGS{'ids'} }, '@POINTS' );


sub new {
    my ( $class, %arg ) = @_;
    bless { _id => $arg{id} }, $class;
}


1;

__END__

=pod

=encoding UTF-8

=head1 NAME

AstroScript::Ephemeris::Point - Base class for miscallenous points of the Celestial Sphere.

=head1 SYNOPSIS

  package AstroScript::Ephemeris::Point::LunarNode;
  use base qw/AstroScript::Ephemeris::Point/;
  use AstroScript::Ephemeris::Point qw/$LN/;
  ...

    sub  new {
        sub new {
            my $class = shift;
            $class->SUPER::new( id => $LN );
        }
    }


=head1 DESCRIPTION

Base class for a planet. Designed to be extended. Used internally in
AstroScript::Ephemeris modules.

The interface is similar to that of L<AstroScript::Ephemeris::Planet>. Subclasses
must implement:

=over

=item * new(), the constructor

=item * position($t, %options)

=back

=head1 EXPORTED CONSTANTS

=over

=item B<$LN> Ascending Lunar Node

=item B<$AS> Ascendant

=item B<$MC> MidHeaven

=item B<$EP> East Point

=item B<$VX> Vertex

=item B<@POINTS> all of the above in array

=back


=head1 AUTHOR

Sergey Krushinsky, C<< <krushinsky at gmail.com> >>

=head1 COPYRIGHT AND LICENSE

Copyright (C) 2009-2019 by Sergey Krushinsky

This library is free software; you can redistribute it and/or modify
it under the same terms as Perl itself.

=cut
