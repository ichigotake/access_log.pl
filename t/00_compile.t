use strict;
use warnings;
use Test::More;

`perl -Mlib::core::only -c access_log.pl`;

is $?, 0;

done_testing;