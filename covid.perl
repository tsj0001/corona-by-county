#!/usr/bin/perl
use warnings;
use strict;
use Getopt::Long qw(GetOptions);
use Text::CSV;
#use Text::CSV qw(csv);
#use Git::Repository;

my $input; # = $ARGV[0];
my $county;
my $state;
my $filename = './us-counties.csv';
my $outfile;
#my $aoa = csv (in => "us-counties.csv");

#csv (in => $aoa, out => "file.csv", sep_char=> ";");


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

my @rows;
#my $csv = Text::CSV->new ()
my $csv = Text::CSV->new ({ binary => 1, auto_diag => 1 });
open my $fh, "<:encoding(utf8)", "us-counties.csv" or die "us-counties.csv: $!";
while (my $row = $csv->getline ($fh)) {
    #print $row->[2];
    $row->[2] =~ m/$state/ && $row->[1] =~ m/$county/ or next; # 3rd field should match
    #print "hi";
    push @rows, $row;
    }
close $fh;

# and write as CSV
#my $csv = Text::CSV->new ({ binary => 1, auto_diag => 1 });
open $fh, ">:encoding(utf8)", "$state-$county.csv" or die "$state-$county.csv: $!";
$csv->say ($fh, $_) for @rows;
close $fh or die "new.csv: $!";


#$input = "${county},${state}";

#if(not defined $input) {
#    $input ="Madison,Alabama";
#}

#my @locales = split(/,/,$input);
#$county = $locales[0];
#$state = $locales[1];
#$outfile = "${county}-${state}.csv";
#open(FH, '<', $filename) or die $!;
#open(FH_OUT, '>',  $outfile) or die$!;
#print FH_OUT "date,cases\n";
#print("File $filename opened successfully!\n");
#while(<FH>) {
#    if($_ =~ "${county},${state}") {
#        my @tokens = split(/,/,$_);
#        my $date = $tokens[0];
#        my $cases = $tokens[4];
        #foreach my $token (@tokens) {
        #    print $token;
        #}
#        print $date , "," , $cases, "\n";
#        print FH_OUT $date,",",$cases,"\n";
#    }
#}
close(FH);
close(FH_OUT);
