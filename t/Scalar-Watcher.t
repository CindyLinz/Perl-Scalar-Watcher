# Before 'make install' is performed this script should be runnable with
# 'make test'. After 'make install' it should work as 'perl Scalar-Watcher.t'

#########################

# change 'tests => 1' to 'tests => last_test_to_print';

use strict;
use warnings;

use Test::More tests => 17;
BEGIN {
    use_ok('Scalar::Watcher');
    Scalar::Watcher->import(qw(when_modified));
};

#########################

# Insert your test code below, the Test::More module is use()ed here so read
# its man page ( perldoc Test::More ) for help writing this test script.

my @out;
{
    my $out;
    {
        my $a = 123;
        $a = 456;
        when_modified $a, sub { $out = $_[0] };
        $a = 789;
        is($out, 789, "when_modified");
        $a = 'abc';
        is($out, 'abc', "when_modified");
    }

    {
        my $a = 345;
        my $canceller = when_modified $a, sub { $out = $_[0] };
        $a = 678;
        is($out, 678, "before cancel");
        undef $canceller;
        $a = 876;
        is($out, 678, "after cancel");
    }

    {
        my($out1, $out2);
        my $a = 123;
        my $canceller1 = when_modified $a, sub { $out1 = $_[0] };
        $a = 456;
        is($out1, 456, 'double 1-1');
        is($out2, undef, 'double 1-2');
        my $canceller2 = when_modified $a, sub { $out2 = $_[0] };
        $a = 789;
        is($out1, 789, 'double 2-1');
        is($out2, 789, 'double 2-2');
        undef $canceller1;
        $a = 678;
        is($out1, 789, 'double 3-1');
        is($out2, 678, 'double 3-2');
    }

    {
        my($out1, $out2);
        my $a = 123;
        my $canceller1 = when_modified $a, sub { $out1 = $_[0] };
        $a = 456;
        is($out1, 456, 'Double 1-1');
        is($out2, undef, 'Double 1-2');
        my $canceller2 = when_modified $a, sub { $out2 = $_[0] };
        $a = 789;
        is($out1, 789, 'Double 2-1');
        is($out2, 789, 'Double 2-2');
        undef $canceller2;
        $a = 678;
        is($out1, 678, 'Double 3-1');
        is($out2, 789, 'Double 3-2');
    }
}
