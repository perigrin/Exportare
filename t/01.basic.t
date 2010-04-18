#!/usr/bin/env perl
use strict;
use Test::More;

BEGIN { $INC{'Foo.pm'}++ }
{

    package Foo;
    use Exportare;
    BEGIN { our @EXPORT = qw(this); }
    sub this { ::pass('this') }
}
{

    package Bar;
    use Foo;

    package main;
    Bar::this();
}

{

    package Baz;
    use Foo this => { -as => 'that' };

    package main;
    Baz::that();
}

done_testing;
