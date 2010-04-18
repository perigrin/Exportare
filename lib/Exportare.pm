package Exportare;
use strict;
use Sub::Install;
our @EXPORT = qw(import);

sub import {
    my ( $exporter, @imports ) = @_;
    my ($caller) = caller;
    my %imports;
    if ( !@imports ) {    # default export
        no strict 'refs';
        %imports = map { $_ => $exporter->can($_) } @{ $exporter . '::EXPORT' };
    }
    elsif ( grep { ref } @imports ) {    # have an optlist
        my @copy = @imports;
        while ( my ( $name, $opts ) = splice( @copy, 0, 2 ) ) {
            my $new_name =
                exists $opts->{'-as'}     ? $opts->{'-as'}
              : exists $opts->{'-prefix'} ? $opts->{'-prefix'} . $name
              : exists $opts->{'-suffix'} ? $name . $opts->{'-suffix'}
              :                             $name;
            $imports{$new_name} = $exporter->can($name);
        }
    }
    else {
        %imports = map { $_ => $exporter->can($_) } @imports;
    }
    _export( $exporter, $caller, %imports );
}

sub _export {
    my ( $from, $to, %import ) = @_;
    for my $name ( keys %import ) {
        Sub::Install::install_sub {
            code => $import{$name},
            into => $to,
            as   => $name,
        };
    }
}

1;
__END__
