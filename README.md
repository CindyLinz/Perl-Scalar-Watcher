# NAME

Scalar::Watcher - watch a scalar variable when setting value or destroying it

# SYNOPSIS

```perl
use Scalar::Watcher qw(when_modified when_destroyed);

{
  my $a = 123;
  $a = 456;
  when_modified $a, sub { print "catch $_[0]\n" };
  when_destroyed $a, sub { print "destroy $_[0]\n" };
  $a = 'oo';
  $a = 567;

  # then you'll get
  # catch oo
  # catch 567
  # destroy 567
}

{
  # or with a canceller
  my $a = 123;
  my $canceller = when_modified $a, sub { print "catch $_[0]\n" };
  my $canceller2 = when_destroyed $a, sub { print "destroy $_[0]\n" };
  $a = 456;
  undef $canceller;
  $a = 789;
  undef $canceller2;

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
```

# DESCRIPTION

Create watchers to monitor a scalar variable after setting or before destroying the variable.

## SUGGESTION

It's better only use this mod on logging or debugging.
Use the mod to track why/when certain variable's value goes wrong.

I think it's usually a bad practice to use the mod to create special triggers.
Because when reading code, we reasonably suppose that a variable is only a variable.
There shouldn't be any magical triggers.
BUT. If you create a whole framework or scenario such as reactive programming
and with consistent naming conventions that everyone who read your code will quickly know
which variables are special triggers, then it might not be bad.

It's not much useful to use `when_destroyed` watching on a lexical variable.
Because the variable's life is just the same as the containing block.
It's useful when watching an entry of a hash or an array.
We use it to see if the whole containing hash or array is replaced unexpectedly.

## EXPORT

- when\_modified $variable, $handler
- $canceller = when\_modified $variable, $handler

    The $handler should be a sub reference, that will be invoked after
    each time the $variable is set.
    The $variable will be the first argument when the $handler is invoked.

    If when\_modified is invoked at void context, the watcher will be active
    until the end of $variable's life; otherwise, it'll return a reference to a canceller,
    to cancel this watcher when the canceller is garbage collected.

    The canceller will hold a weaken reference to the $variable.
    Holding the canceller only will not prevent $variable itself from garbage collected.

    There could be more than one watchers on the same variable,
    the notifying order is not specified. It's better not to change
    the value of the watched variable if there are more than one watchers on it.

    There's also a good practice not to access the watched variable directly
    in the handler, or you should remember to solve the circular references.

- when\_destroyed $variable, $handler
- $canceller = when\_destroyed $variable, $handler

    It behaves like `when_modified`, except triggered when the variable is destroyed.

# SEE ALSO

github: [https://github.com/CindyLinz/Perl-Scalar-Watcher](https://github.com/CindyLinz/Perl-Scalar-Watcher)

# AUTHOR

Cindy Wang (CindyLinz)

# COPYRIGHT AND LICENSE

Copyright (C) 2014 by Cindy Wang (CindyLinz)

This library is free software; you can redistribute it and/or modify
it under the same terms as Perl itself, either Perl version 5.18.2 or,
at your option, any later version of Perl 5 you may have available.
