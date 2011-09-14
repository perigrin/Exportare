package Exportare;
use strict;
use Carp qw(carp);
use Sub::Install;
use Devel::Pragma qw(ccstash my_hints new_scope scope);

our @EXPORT = qw(import);

use namespace::clean     ();
use B::Hooks::EndOfScope ();

sub import {
    my ( $exporter, @imports ) = @_;
    my $caller = ccstash;
    my %imports;
    if ( !@imports ) {    # default export
        no strict 'refs';
        %imports
            = map { $_ => $exporter->can($_) } @{ $exporter . '::EXPORT' };
    }
    elsif ( grep {ref} @imports ) {    # have an optlist
        my @copy = @imports;
        while ( my ( $name, $opts ) = splice( @copy, 0, 2 ) ) {
            my $new_name
                = exists $opts->{'-as'}     ? $opts->{'-as'}
                : exists $opts->{'-prefix'} ? $opts->{'-prefix'} . $name
                : exists $opts->{'-suffix'} ? $name . $opts->{'-suffix'}
                :                             $name;
            $imports{$new_name} = $exporter->can($name);
        }
    }
    else {
        %imports = map { $_ => $exporter->can($_) } @imports;
    }

    my $hints     = my_hints;
    my $top_level = 1;
    for my $name ( keys %imports ) {
        if ( my $code = $caller->can($name) ) {
            $top_level = 0;
            $hints->{restore}{$name} = $code;
            namespace::clean->clean_subroutines( $caller, keys %imports );
        }
        Sub::Install::install_sub {
            code => $imports{$name},
            into => $caller,
            as   => $name,
        };
    }

    unless ($top_level) {
        B::Hooks::EndOfScope::on_scope_end {
            my $hints = my_hints;
            namespace::clean->clean_subroutines( $caller, keys %imports );
            for my $name ( keys %{ $hints->{restore} } ) {
                Sub::Install::install_sub {
                    code => $hints->{restore}{$name},
                    into => $caller,
                    as   => $name,
                };
            }
        }
    }

}
1;
__END__
