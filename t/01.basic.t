#!/usr/bin/env perl
use strict;
use Test::More;

BEGIN { $INC{'Foo.pm'}++ }
{

    package Foo;
    use Exportare;
    BEGIN { our @EXPORT = qw(this); }
    sub this { ::pass(shift) }
}
{

    package Bar;
    use Foo;

    package main;
    Bar::this('Bar::this');
}

{

    package Bar::That;
    use Foo this => { -as => 'that' };

    package main;
    Bar::That::that('Bar:That::that');
}

{

    package Bar::Prefix;
    use Foo this => { -prefix => 'foo_' };

    package main;
    Bar::Prefix::foo_this('Bar::Prefix::foo_this');
}

{

    package Bar::Suffix;
    use Foo this => { -suffix => '_foo' };

    package main;
    Bar::Suffix::this_foo('Bar::Suffix::this_foo');
}

done_testing;
