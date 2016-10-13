use strict;
use warnings;
use Text::Diff qw/ diff /;
use Path::Tiny;
use Test::More;

my $md = `pod2markdown access_log.pl`;

my $badge_url = 'https://travis-ci.org/ichigotake/access_log.pl.svg';
my @diff = grep {m/^[\+\-]/}    # include diff only
        grep {!m/^[\+\-]$/}     # exclude blank line in diff
        grep {!m/$badge_url/}   # exclude badge in diff
        split("$/", diff('README.md', \$md, {STYLE => 'OldStyle'}));

is scalar(@diff), 0;

done_testing;
