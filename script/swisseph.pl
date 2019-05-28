#!/usr/bin/env perl
################################################################################
# Make a seria of requests to http://www.astro.com,
# to aquire data calculated with the Swiss Ephemeris.
# These datasets may be used for testing.
################################################################################

use strict;
use warnings;
use LWP::UserAgent;
use URI;
use Getopt::Long;
use HTML::TreeBuilder;
use Readonly;
use Data::Dumper;
binmode STDOUT, 'utf8';
use YAML qw/DumpFile/;


use Log::Log4perl qw/:easy/;
Log::Log4perl->easy_init( $INFO  );
use FindBin qw/$Bin/;
#use lib "$Bin../lib";
use DateTime;

Readonly our $URL => 'http://www.astro.com/cgi/swetest.cgi';
Readonly our $USAGE => <<USAGE
Get ephemeris data calculated with Swiss Ephemeris.

Usage:
%s OPTIONS

Options:
--help       : display this help message
--delay      : sleep time between requests in seconds, default: 10
--step       : step in years, default=-50
USAGE
;


Readonly our $DEFAULT_DELAY => 10;
Readonly our $DEFAULT_STEP  =>-10; # Default step in years
Readonly our $AGENT => 'Mozilla/5.0 (Windows; U; Windows NT 5.1; en-US; rv:1.3) Gecko/20030312';
Readonly::Array our @PLANETS => qw/Sun Moon Mercury Venus Mars Jupiter Saturn Uranus Neptune Pluto/;
Readonly our $DATE_FORMAT => '%Y-%m-%d %H:%M %Z';

use constant {
    STATE_INIT    => 0,
    STATE_REQUEST => 1,
    STATE_SCRAP   => 2,
    STATE_EXIT    => 3,
    STATE_ERROR   => 5,
    STATE_WAIT    => 6,
    STATE_SAVE    => 7,
};


sub scrap_page {
    my ($html, $handler) = @_;
    my $tree = HTML::TreeBuilder->new_from_content($html);
    my $pre = $tree->find_by_tag_name('pre');
    $handler->($pre->as_text) if $pre;
    $tree->delete;
}



sub parse_content {
    my ($data, $handler) = @_;
    my $rec;
    my $i = 0;
    for ( split(/\s*\n\s*/, $data) ) {
        next if ++$i < 4;
        if ($i == 4) {
            my ($hdr, $val) = split /\s*:\s*/;
            $rec->{ET} = $val;
            next;
        }
        my @cols = split(/\s*#\s*/);
        #print Dumper(\@cols);
        my $name = shift @cols;
        if (grep /$name/, @PLANETS ) {
            $rec->{Planets}->{$name} = \@cols;
        }
        elsif ($name =~ /true Node/i ) {
            $rec->{Planets}->{'True Node'} = \@cols;
        }
        elsif ($name =~ /Obl/i) {
            $rec->{'Ecliptic Obliquity'} = $cols[0];
        }
        elsif ($name =~ /Delta T/i) {
            $rec->{'Delta-T'} = $cols[0];
        }
        elsif ($name =~ /Nutation/i) {
            $rec->{'Nutation'} = $cols[0];
        }
    }

    $handler->($rec);
}



my $delay = $DEFAULT_DELAY;
my $help;
my $step  = $DEFAULT_STEP;;

GetOptions(
    'help'         => \$help,
    'delay:i'      => \$delay,
    'step:i'       => \$step,
);

if ($help) {
    printf $USAGE, $0;
    exit 0;
}

my $ua = LWP::UserAgent->new(
    agent => $AGENT,
);
$ua->env_proxy; # get proxy settings from the environment.
                # http_proxy=http://login:password@192.168.0.7:3128/

my $state = STATE_INIT;
my $error;
my $html;

my %params = (
    s   => '1',
    n   => '1',
    p   => '0123456789tnoq', # planets, N.Node, obliquity, delta-T
    e   => '-eswe',          # use Swiss Ephemeris
    f   => 'Plbrs',          # output name, longitude, latitude, distance, daily motion;
                             # all numbers as decimals
    arg => '-g#',            # include header
    b   => 'j2438792.990278' # Julian day
);

#b=j2438792.990278&n=1&s=1&p=0123456789tnoq&e=-eswe&f=PLBRS&arg=%2Bhead

my $start_date = DateTime->new(
    year       => 3000,
    month      => 1,
    day        => 1,
    hour       => 12,
    minute     => 0,
    second     => 0,
    nanosecond => 0,
    time_zone  => 'UTC',
);


my $end_date = DateTime->new(
    year       => 1000,
    month      => 1,
    day        => 1,
    hour       => 12,
    minute     => 0,
    second     => 0,
    nanosecond => 0,
    time_zone  => 'UTC'
);

my $dt = $start_date;

my $filename = sprintf(
    "swisseph-%d-%d.yml",
    $start_date->year,
    $end_date->year,
);

my @yaml;

STATE:
while (1) {
    if ($state == STATE_ERROR) {
        die $error;
    }
    elsif ($state == STATE_EXIT) {
        DEBUG("Exiting...");
        last;
    }
    elsif ($state == STATE_WAIT) {
        DEBUG(sprintf('waiting %.2f seconds...', $delay));
        sleep $delay;
        $state = STATE_REQUEST;
    }
    elsif ($state == STATE_INIT) {
        INFO(
             sprintf(
                "Period: %s -- %s Step: %d yr.",
                $dt->strftime($DATE_FORMAT),
                $end_date->strftime($DATE_FORMAT),
                $step,
            )
        );
       $state = STATE_REQUEST;
    }
    elsif ($state == STATE_REQUEST) {
        INFO(sprintf($dt->strftime($DATE_FORMAT)));
        $params{b} = sprintf('j%f', $dt->jd);
        my $resp = $ua->post($URL, \%params);

        if ($resp->is_success) {
            $html = $resp->decoded_content;
            $state = STATE_SCRAP;
        }
        else {
            $error = $resp->message;
            $state = STATE_ERROR;
        }
    }
    elsif ($state == STATE_SCRAP) {
        eval {
            DEBUG 'Parsing result...';
            scrap_page(
                $html,
                sub {
                    parse_content(
                        @_,
                        sub {
                            my $rec = shift;
                            $rec->{Date} = $dt->strftime($DATE_FORMAT);
                            $rec->{JD} = $dt->jd;
                            push @yaml, $rec;
                        }
                    )
                },
            )
        };
        if ($@) {
            $error = $@;
            $state = STATE_ERROR
        }
        else {
            $dt->add(years => $step);
            if (DateTime->compare( $dt, $end_date ) > -1) {
                $state = $step < 0 ? STATE_WAIT : STATE_SAVE
            }
            else {
                $state = $step < 0 ? STATE_SAVE : STATE_WAIT
            }
        }

    }
    elsif ($state == STATE_SAVE) {
        DEBUG 'Saving...';
        DumpFile($filename, \@yaml);
        $state = STATE_EXIT;
    }
}

INFO('Done.');
