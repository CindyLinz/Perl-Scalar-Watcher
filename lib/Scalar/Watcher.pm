package Scalar::Watcher;

use 5.008;
use strict;
use warnings;
use Carp;

require Exporter;
use AutoLoader;

our @ISA = qw(Exporter);

our @EXPORT_OK = qw(when_modified when_freed);

our $VERSION = '0.001';

require XSLoader;
XSLoader::load('Scalar::Watcher', $VERSION);

# Preloaded methods go here.

# Autoload methods go after =cut, and are processed by the autosplit program.

1;
__END__
# Below is stub documentation for your module. You'd better edit it!

=head1 NAME

Scalar::Watcher - watch a scalar variable when value changed or freed

=head1 SYNOPSIS

  use Scalar::Watcher qw(when_modified);

  {
    my $a = 123;
    $a = 456;
    when_modified $a, sub { print "catch $_[0]\n" };
    when_freed $a, sub { print "freed $_[0]\n" };
    $a = 'oo';
    $a = 567;

    # then you'll get
    # catch oo
    # catch 567
    # freed 567
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

=head1 DESCRIPTION

Stub documentation for Scalar::Watcher, created by h2xs. It looks like the
author of the extension was negligent enough to leave the stub
unedited.

Blah blah blah.

=head2 EXPORT

None by default.



=head1 SEE ALSO

Mention other useful documentation such as the documentation of
related modules or operating system documentation (such as man pages
in UNIX), or any relevant external documentation such as RFCs or
standards.

If you have a mailing list set up for your module, mention it here.

If you have a web site set up for your module, mention it here.

=head1 AUTHOR

Cindy Wang (CindyLinz), E<lt>cindy@cpan.orgE<gt>

=head1 COPYRIGHT AND LICENSE

Copyright (C) 2014 by Cindy Wang (CindyLinz)

This library is free software; you can redistribute it and/or modify
it under the same terms as Perl itself, either Perl version 5.18.2 or,
at your option, any later version of Perl 5 you may have available.


=cut
