package AstroScript::Aspects::Constants;

use strict;
use warnings;


use Exporter qw/import/;
use Readonly;

our $VERSION = '1.00';

# Influences
Readonly our $NEUTRAL  => 'Neutral';
Readonly our $POSITIVE => 'Positive';
Readonly our $NEGATIVE => 'Negative';
Readonly our $CREATIVE => 'Creative';

# Types
Readonly our $MAJOR  => 0x1;
Readonly our $MINOR  => $MAJOR << 1;
Readonly our $KEPLER => $MAJOR << 2;

Readonly::Array our @INFLUENCES => qw/$NEUTRAL $POSITIVE $NEGATIVE $CREATIVE/;
Readonly::Array our @TYPES => qw/$MAJOR $MINOR $KEPLER/;

our %EXPORT_TAGS = (
    influences => \@INFLUENCES,
    types      => \@TYPES,
);

our @EXPORT_OK = (
    @{ $EXPORT_TAGS{'types'} },
    @{ $EXPORT_TAGS{'influences'} },
);


1;
__END__

=pod

=encoding UTF-8

=head1 NAME

AstroScript::Aspects::Constants

=head1 SYNOPSIS

  use AstroScript::Aspects::Constants qw/:types :influences/;

=head1 DESCRIPTION

Constants used by aspects-related modules.

=head1 EXPORTED CONSTANTS

=head2 Influences

=over

=item * C<$POSITIVE>

=item * C<$NEGATIVE>

=item * C<$NEUTRAL>

=item * C<$CREATIVE>

=back

=head2 Aspect Types

=over

=item * C<$MAJOR>

=item * C<$MINOR>

=item * C<$KEPLER>

=back



=head1 AUTHOR

Sergey Krushinsky, C<< <krushinsky at gmail.com> >>

=head1 COPYRIGHT AND LICENSE

Copyright (C) 2009-2019 by Sergey Krushinsky

This library is free software; you can redistribute it and/or modify
it under the same terms as Perl itself.

=cut
