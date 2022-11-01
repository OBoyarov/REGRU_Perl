#!/usr/bin/perl
use strict;
use warnings;

my $datetime = "2016-04-11 20:59:03";

my @dt_spl = split /[\s\/]+/, $datetime;

my $date = $dt_spl[0];
my $time = $dt_spl[1];
print "Datetime: " . $datetime . "\nDate: " . $date . "\nTime: " . $time . "\n";


