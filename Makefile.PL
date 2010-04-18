use strict;
use inc::Module::Install;

all_from 'lib/Exportare.pm';

requires 'Sub::Install';

test_requires 'Test::More' => 0.90;

WriteAll;