package AstroScript::Helpers;

use strict;
use warnings;

use Exporter qw/import/;

our $VERSION = '1.00';

use Readonly;

Readonly::Array our @ZODIAC =>
  qw/Aries Taurus Gemini Cancer Leo Virgin Libra Scorpio
  Sagittarius Capricorn Aquarius Pisces/;

our @EXPORT_OK = qw/parse_geocoords  dmsz_str dms_or_dec_str
  dmsdelta_str @ZODIAC/;

use AstroScript::MathUtils qw/dms zdms frac/;

sub parse_geocoords {
    my %arg = @_;
    my ( $lon, $lat ) = ( 0, 0 );
    if ( defined $arg{l} ) {
        $arg{l} =~ /^(\d+)(E|W)(\d+)$/;
        my $d = $1 or die 'Unexpected longitude degrees';
        my $w = $2 or die 'Unexpected longitude direction';
        my $m = $1 or die 'Unexpected longitude minutes';
        $lon = $d + $m / 60;
        $lon = -$lon if $w eq 'E';
    }
    if ( defined $arg{m} ) {
        $arg{m} =~ /^(\d+)(S|N)(\d+)$/;
        my $d = $1 or die 'Unexpected longitude degrees';
        my $n = $2 or die 'Unexpected longitude direction';
        my $m = $1 or die 'Unexpected longitude minutes';
        $lat = $d + $m / 60;
        $lat = -$lat if $n eq 'S';
    }
    $lon, $lat;
}

sub dmsz_str {
    my $x = shift;
    my %arg = ( decimal => 0, @_ );
    my ( $s, $d, $m ) = zdms($x);
    my $z = substr( $ZODIAC[$s], 0, 3 );
    if ( $arg{decimal} ) {
        sprintf( '%05.2f %s', ( $x % 30 ) + frac($x), $z );
    }
    else {
        sprintf( '%02d:%02d %s', $d, $m, $z );
    }
}

sub dms_str {
    my $x = shift;
    sprintf( '%03d:%02d:%02d', dms($x) );
}

sub dms_or_dec_str {
    my $x   = shift;
    my %arg = ( decimal => 0, places => 3, sign => 0, @_ );
    my $s   = $arg{sign} ? ( $x < 0 ? '-' : '+' ) : '';

    if ( $arg{decimal} ) {
        my $f = sprintf( '0%d', $arg{places} + 3 );
        my $fmt = "$s%$f.2f";
        sprintf( $fmt, abs($x) );
    }
    else {
        my $f = sprintf( '0%dd', $arg{places} );
        my $fmt = "$s%$f:%02d:%02d";
        sprintf( $fmt, dms( abs($x) ) );
    }
}

sub hms_str {
    my $x = shift;
    my %arg = ( decimal => 0, @_ );
    $arg{decimal}
      ? sprintf( '05.2f',          $x )
      : sprintf( '%02d:%02d:%02d', dms($x) );
}

sub latde_str {
    my $y = shift;
    my %arg = ( decimal => 0, @_ );
    if ( $arg{decimal} ) {
        sprintf( '05.2f', $y );
    }
    else {
        sprintf( '%s%02d:%02d:%02d', $y < 0 ? '-' : '+', dms($y) );
    }
}

1;

__END__

_END__

=pod

=encoding UTF-8

=head1 NAME

AstroScript::Helpers - Helper functions for scripts.

=head1 VERSION

Version 1.00

=head1 DESCRIPTION

Helper functions for scripts, mainly string related.

=head1 EXPORT

=over

=item * L<< /parse_geocoords(l => number, m => number) >>

=item * L<< /dmsz_str($x, decimal => boolean) >>

=item * L</dms_str($x)>

=item * L<< /dms_or_dec_str($x, decimal => boolean, places => N, sign => boolean) >>

=item * L<< /hms_str($x, $decimal => boolean) >>

=item * L<< /latde_str($h, $decimal => boolean) >>

=back

=head1 FUNCTIONS

=head2 parse_geocoords(l => number, m => number)

Parse geographical coordinates

=head3 Named Arguments

=over

=item * B<l> — longitude in degrees

=item * B<m> — latitude in degrees

=back

=head3 Returns

List of formatted longitude and latitude, e.g: C<037E35>, C<55N45>.


=head2 dmsz_str($x, decimal => boolean)

Given ecliptic longitude B<$x>, return string with Zodiac position:
C<12:30 Aqu> or C<312.50 Aqu> depending on B<decimal> option.

=head3 Options

=over

=item * B<decimal> — return decimal degrees instead of degrees and minutes.

=back

=head2 dms_str($x)

Given ecliptic longitude B<$x>, return string of formatted degrees, minutes
and seconds, e.g.: C<312:30:02>.

=head2 dms_or_dec_str($x, decimal => boolean, places => N, sign => boolean)

Format ecliptic longitude B<$x>.

=head3 Options

=over

=item * B<decimal> — return decimal degrees instead of degrees and minutes. Default is I<false>

=item * B<places> — number of arc-degrees digits. If C<$x = 1>, C<3> gives C<001>, C<2> gives C<01>, C<1> gives C<1>. Default is B<3>

=item * B<sign> — if I<true>, the number will be prefixed with B<+> or B<->, depending on its sign. Default: I<false>.

=back

=head2 hms_str($x, $decimal => boolean)

Format time value B<$x>.

=head3 Options

=over

=item * B<decimal> — return decimal degrees instead of degrees and minutes.

=back

=head2 latde_str($h, $decimal => boolean)

Format time value B<$h>.

=head3 Options

=over

=item * B<decimal> — return decimal degrees instead of degrees and minutes.

=back



=head1 SUPPORT

You can find documentation for this module with the perldoc command.

    perldoc AstroScript::CoCo

=head1 AUTHOR

Sergey Krushinsky, C<< <krushinsky at gmail.com> >>

=head1 COPYRIGHT AND LICENSE

Copyright (C) 2009-2019 by Sergey Krushinsky

This library is free software; you can redistribute it and/or modify
it under the same terms as Perl itself.

=cut
