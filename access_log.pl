#!/usr/bin/env perl
use strict;
use warnings;
use utf8;
use lib::core::only;
use Getopt::Long qw(:config posix_default no_ignore_case);
use Pod::Usage qw/pod2usage/;
use Time::Piece;

my $days;
my $error_only;
GetOptions(
    "days=i" => \$days,
    "error-only!" => \$error_only,
) or &help();
$days ||= 1;
my $fname = shift or &help();

my $target_time = $days eq 'all' ? 0 : time() - $days*24*60*60;
open my$fh, '<', $fname;
while (my $line = <$fh>) {
    my %ltsv = map {split/:/, $_, 2} split(/\t/, $line);
    my $time = Time::Piece->strptime($ltsv{time}, '%d/%b/%Y:%T %z')->epoch;
    next if $time < $target_time;
    next if (defined($error_only) && $ltsv{status} =~ m/^[^45]/);
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

    $ access_log.pl --error-only /var/log/httpd/access_log

=head1 OPTIONS

    access_log.pl [--days=1] [--error-only] file_name

=head1 Source code

https://github.com/ichigotake/access_log.pl

    git clone https://github.com/ichigotake/access_log.pl

=head1 AUTHOR

ichigotake <ichigotake.san@gmail.com>

=head1 LICENSE

Copyright (C) ichigotake

This library is free software; you can redistribute it and/or modify it under the same terms as Perl itself.

=cut

