#!/usr/bin/perl
use warnings;
use strict;
use Getopt::Long qw(GetOptions);
#use Git::Repository;

my $input; # = $ARGV[0];
my $county;
my $state;
my $filename = './us-counties.csv';
my $outfile;

GetOptions(
    'state=s' => \$state,
    'county=s' => \$county,
) or die "Usage: $0 --STATE\n";

if(not defined $state) {
    $state = "Alabama";
}

if(not defined $county) {
    $county = "Madison";
}

#$input = "${county},${state}";

#if(not defined $input) {
#    $input ="Madison,Alabama";
#}

#my @locales = split(/,/,$input);
#$county = $locales[0];
#$state = $locales[1];
$outfile = "${county}-${state}.csv";
open(FH, '<', $filename) or die $!;
open(FH_OUT, '>',  $outfile) or die$!;
print FH_OUT "date,cases\n";
print("File $filename opened successfully!\n");
while(<FH>) {
    if($_ =~ "${county},${state}") {
        my @tokens = split(/,/,$_);
        my $date = $tokens[0];
        my $cases = $tokens[4];
        #foreach my $token (@tokens) {
        #    print $token;
        #}
        print $date , "," , $cases, "\n";
        print FH_OUT $date,",",$cases,"\n";
    }
}
close(FH);
close(FH_OUT);
