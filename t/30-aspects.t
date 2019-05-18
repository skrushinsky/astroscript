#!/usr/bin/env perl -w

use strict;
use FindBin qw/$Bin/;
use lib ("$Bin/../lib");
use Test::More;
use Test::Number::Delta within => 1e-5;
use AstroScript::Ephemeris::Planet qw/@PLANETS :ids/;

BEGIN {
	use_ok( 'AstroScript::Aspects', qw/:aspects @ASPECTS/ );
    use_ok( 'AstroScript::Aspects::Constants', qw/:types :influences/ );
    use_ok( 'AstroScript::Aspects::Orbs::AspectRatio' );
    use_ok( 'AstroScript::Aspects::Orbs::Dariot' );
    use_ok( 'AstroScript::Aspects::Orbs::DeVore' );
}

eval {
    my @all = @ASPECTS
};
ok(!$@, 'Importing "@ASPECTS" array') or diag $@;

my @planets = (
    {
        id => $MO,
        x  => 310.211118039121
    },
    {
        id => $SU,
        x => 312.430798112358
    },
    {

        id => $ME,
        x => 297.078430402921
    },
    {
        id => $VE,
        x => 295.209360003483
    },
    {
        id => $MA,
        x => 177.966202541024
    },
    {
        id => $JU,
        x => 46.9290328362618
    },
    {
        id => $SA,
        x => 334.601965217279
    },
    {
        id => $UR,
        x => 164.031950787664
    },
    {
        id => $NE,
        x => 229.922411342362
    },
    {
        id => $PL,
        x => 165.825418322174
    }
);



subtest 'Aspects' => sub {
    my @cases = (
        {
            orbs  => AstroScript::Aspects::Orbs::Dariot->new,
            count => {
                $MO => 2,
                $SU => 3,
                $ME => 2,
                $VE => 3,
                $MA => 2,
                $JU => 5,
                $SA => 0,
                $UR => 3,
                $NE => 5,
                $PL => 3
            }
        },
        {
            orbs  => AstroScript::Aspects::Orbs::DeVore->new,
            count => {
                $MO => 1,
                $SU => 2,
                $ME => 2,
                $VE => 2,
                $MA => 2,
                $JU => 4,
                $SA => 0,
                $UR => 2,
                $NE => 1,
                $PL => 2
            }
        },
        {
            orbs  => AstroScript::Aspects::Orbs::AspectRatio->new,
            count => {
                $MO => 2,
                $SU => 3,
                $ME => 2,
                $VE => 3,
                $MA => 2,
                $JU => 5,
                $SA => 0,
                $UR => 3,
                $NE => 5,
                $PL => 3
            }
        },
    );

    subtest 'Iterator interface' => sub {
        plan tests => scalar @cases * 10;

        for my $case (@cases) {
            #diag "@{[$case->{orbs}->name]} orbs";

            my $test = sub {
                my ($src, $dst) = @_;
                my $iter = AstroScript::Aspects->new(
                    orbs => $case->{orbs},
                    type_flags => $MAJOR
                )->iterator($src, $dst);
                my $got = 0;
                while (my $asp = $iter->()) {
                    $got++;
                }
                my $exp = $case->{count}->{$src->{id}};
                cmp_ok($got, '==', $exp, "$src->{id} aspects");
            };

            for my $id (@PLANETS) {
                my $src = (grep { $_->{id} eq $id } @planets)[0];
                my @dst = (grep { $_->{id} ne $id } @planets);
                $test->($src, \@dst);
            }
        }
    };

    subtest 'Callback interface' => sub {
        plan tests => scalar @cases * 10;
        for my $case (@cases) {
            #diag "@{[$case->{orbs}->name]} orbs";
            my $aspects = AstroScript::Aspects->new(
                orbs => $case->{orbs},
                type_flags => $MAJOR
            );
            my $test = sub {
                my ($src, $dst) = @_;
                my $got = 0;
                $aspects->find_aspects_to($src, $dst, sub { $got++ });
                my $exp = $case->{count}->{$src->{id}};
                cmp_ok($got, '==', $exp, "$src->{id} aspects");
            };

            for my $id (@PLANETS) {
                my $src = (grep { $_->{id} eq $id } @planets)[0];
                my @dst = (grep { $_->{id} ne $id } @planets);
                $test->($src, \@dst);
            }
        }
    }
};

subtest 'Stelliums' => sub {
    plan tests => 3;

    {
        my @res;
        AstroScript::Aspects->partition(
            \@planets,
            callback => sub { push @res, \@_ }
        );
        cmp_ok(7, '==', scalar @res, 'Default gap');
    }
    {
        my @res;
        AstroScript::Aspects->partition(
            \@planets,
            gap      => 15,
            callback => sub { push @res, \@_ }
        );
        cmp_ok(5, '==', scalar @res, 'Large gap (15 arc-degrees)');
    }
    {
        my @res;
        AstroScript::Aspects->partition(
            \@planets,
            gap      => 0,
            callback => sub { push @res, \@_ }
        );
        cmp_ok(scalar @planets, '==', scalar @res, 'No gap, each planet should be a group');
    }
};


done_testing();
