package Scalar::Watcher;

use 5.008;
use strict;
use warnings;
use Carp;

require Exporter;
use AutoLoader;

our @ISA = qw(Exporter);

our @EXPORT_OK = qw(when_modified);

our $VERSION = '0.001';

require XSLoader;
XSLoader::load('Scalar::Watcher', $VERSION);

# Preloaded methods go here.

# Autoload methods go after =cut, and are processed by the autosplit program.

1;
__END__

=head1 NAME

Scalar::Watcher - watch a scalar variable when setting value

=head1 SYNOPSIS

  use Scalar::Watcher qw(when_modified);

  {
    my $a = 123;
    $a = 456;
    when_modified $a, sub { print "catch $_[0]\n" };
    $a = 'oo';
    $a = 567;

    # then you'll get
    # catch oo
    # catch 567
  }

  {
    # or with a canceller
    my $a = 123;
    my $canceller = when_modified $a, sub { print "catch $_[0]\n" };
    $a = 456;
    undef $canceller;
    $a = 789;

    # then you'll get
    # catch 456
  }

  {
    # you can bind multiple watchers on one variable
    my $a = 123;
    my $canceller1 = when_modified $a, sub { ... };
    my $canceller2 = when_modified $a, sub { ... };
    $a = 456;

    # and turn off one of them at anytime
    undef $canceller1;
    $a = 789;
  }

=head1 DESCRIPTION

Create watchers to monitor a scalar variable after setting the variable.

=head2 EXPORT

=over 4

=item when_modified $variable, $handler
=item $canceller = when_modified $variable, $handler

The $handler should be a sub reference, that will be invoked after
each time the $variable is set.
The $variable will be the first argument when the $handler is invoked.

If when_modified is invoked at void context, the watcher will be active
until the end of $variable's life; otherwise, it'll return a reference to a canceller,
to cancel this watcher when the canceller is garbage collected.

The canceller will hold a weaken reference to the $variable.
Holding the canceller only will not prevent $variable itself from garbage collected.

There could be more than one watchers on the same variable,
the notifying order is not specified. It's better not to change
the value of the watched variable if there are more than one watchers on it.

There's also a good practice not to access the watched variable directly
in the handler, or you should remember to solve the circular references.

=back

=head1 SEE ALSO

github: L<https://github.com/CindyLinz/Perl-Scalar-Watcher>

=head1 AUTHOR

Cindy Wang (CindyLinz)

=head1 COPYRIGHT AND LICENSE

Copyright (C) 2014 by Cindy Wang (CindyLinz)

This library is free software; you can redistribute it and/or modify
it under the same terms as Perl itself, either Perl version 5.18.2 or,
at your option, any later version of Perl 5 you may have available.


=cut
