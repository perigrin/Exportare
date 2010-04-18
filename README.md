# Exportare 

What would happen if Sub::Exporter and Exporter::Lite had a baby.

## Synopsis 

    package Foo;
    use 5.12;
    use Exportare;
    our @EXPORT = qw(run);
    
    sub run { ... }
    
    package Bar;
    use Foo run => { -as => 'run_fast' }
    
    sub run { 
        run_fast(); # hide good
    }


## Description

While playing with a module that used Export::Lite it came up that we
would really like to have Sub::Exporter style remapping of imports.
Something between the two was really needed. Rather than poking about
CPAN and trying to find something that mostly sort of kind of would do,
I decided to re-invent the wheel.

## WTF? 

I blame miyagawa's drugs.
