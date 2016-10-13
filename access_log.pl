#!/usr/bin/env perl
use strict;
use warnings;
use utf8;
use Getopt::Long qw(:config posix_default no_ignore_case bundling auto_help auto_version);
use Pod::Usage qw/pod2usage/;
use Time::Piece;

our $VERSION = '0.1';

my $days;
my $error_only;
my @query = ();
GetOptions(
    "days=i" => \$days,
    "error-only!" => \$error_only,
    "pattern|p=s" => \@query,
) or &help();
$days ||= 1;
my $fname = shift or &help();

my $target_time = $days > 0 ? time() - $days*24*60*60 : 0;
open my$fh, '<', $fname;
while (my $line = <$fh>) {
    my %ltsv = map {split/:/, $_, 2} split(/\t/, $line);
    my $time = Time::Piece->strptime($ltsv{time}, '%d/%b/%Y:%T %z')->epoch;
    next if $time < $target_time;
    next if (defined($error_only) && $ltsv{status} =~ m/^[^45]/);
    if (@query) {
        my $matched = 1;
        for my$q (@query) {
            my ($key, $pattern) = split(/:/, $q, 2);
            if ($pattern =~ m{^/(.+)/$}) {
                my $macher = $1;
                $matched = 0 unless $ltsv{$key} =~ m{$macher};
            } else {
                $matched = 0 unless $ltsv{$key} eq $pattern;
            }
        }
        next unless $matched;
    }
    print $line;
}
close $fh;

sub help {
    pod2usage(-verbose => 2);
    die;
}

__END__

=head1 NAME

access_log.pl - Apache access log (as LTSV) searcher

=head1 SYNOPSIS

    $ access_log.pl --error-only -p "method:/(POST)|(PUT))/" /var/log/httpd/access_log

=head1 OPTIONS

    access_log.pl [--days=1] [--error-only] [-p "key:/regex/"]file_name

=head1 Source code

L<https://github.com/ichigotake/access_log.pl>

    git clone https://github.com/ichigotake/access_log.pl

=head1 AUTHOR

ichigotake E<lt>ichigotake.san@gmail.comE<gt>

=head1 LICENSE

Copyright (C) ichigotake

This library is free software; you can redistribute it and/or modify it under the same terms as Perl itself.

=cut

