# Before 'make install' is performed this script should be runnable with
# 'make test'. After 'make install' it should work as 'perl Scalar-Watcher.t'

#########################

# change 'tests => 1' to 'tests => last_test_to_print';

use strict;
use warnings;

use Test::More tests => 3;
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
}
