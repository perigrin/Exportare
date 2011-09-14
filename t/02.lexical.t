#!/usr/bin/env perl
use strict;
use Test::More;

BEGIN { $INC{'Foo.pm'}++ }
{

    package Foo;
    use Exportare;
    BEGIN { our @EXPORT = qw(this); }

    sub this {'Foo::this'}
}

sub this {'main::this'}

is this(), 'main::this', 'main::this';

{
    use Foo;
    is this(), 'Foo::this', 'Foo::this';
}

is this(), 'main::this', 'main::this (again)';

{
    use Foo this => { -as => 'that' };
    is that(), 'Foo::this', 'this as that';
}

is this(), 'main::this', 'main::this (again)';

{
    use Foo this => { -prefix => 'foo_' };
    is foo_this(), 'Foo::this', 'foo_this';
}

is this(), 'main::this', 'main::this (again)';

{
    use Foo this => { -suffix => '_foo' };
    is this_foo(), 'Foo::this', 'this_foo';
}

is this(), 'main::this', 'main::this (again)';

done_testing;
