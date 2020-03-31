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
my $usefile;
my $getcounties;
#my $aoa = csv (in => "us-counties.csv");

#csv (in => $aoa, out => "file.csv", sep_char=> ";");


GetOptions(
    'state=s' => \$state,
    'county=s' => \$county,
    'usefile' => \$usefile,
    'getcounties' => \$getcounties
) or die "Usage: $0 --STATE\n";

my $timestamp = getLoggingTime();
mkdir "${timestamp}" or die "peepee";

#open my $fh, "<:encoding(utf8)", "us-counties.csv" or die "us-counties.csv: $!";
if($getcounties) {
    my %counties;
    my $csv = Text::CSV->new ({ binary => 1, auto_diag => 1 });
    open my $fh1, "<:encoding(utf8)", "us-counties.csv" or die "us-counties.csv: $!";
    open fh2, '>>', "${timestamp}/counties.dat" or die "counties.dat: $!";
    while (my $row = $csv->getline($fh1)) {
        $input = $row->[1] .",". $row->[2];
        $counties{$input} = 1;

    }
    foreach my $input (keys %counties) {
        print fh2 $input,"\n";
    }
}

#if($usefile) {
    my @counties;
    #my $csv = Text::CSV->new ()
    my $csv = Text::CSV->new ({ binary => 1, auto_diag => 1 });
    #print "hello !!!";
    open fh2, "<:encoding(utf8)", "${timestamp}/counties.dat" or die "counties.dat: $!";
    while(<fh2>) {
        chomp($_);
        push @counties, $_;
    }
    #print @counties;
    #foreach my $element (@counties) {
    #    print $element,"\n";
    #}

    open my $fh2, "<:encoding(utf8)", "us-counties.csv" or die "us-counties.csv: $!";
    while (my $row = $csv->getline($fh2)) {
        $input = $row->[1] .",". $row->[2];
        my $output = $row->[0] .",". $row->[4];
        my $filename_county = $row->[1] ."-". $row->[2];
        foreach my $element (@counties) {
            #print $element,"  ",$input,"\n";
            if($input =~ m/$element/) {
                open FH, '>>', "${timestamp}/${filename_county}.csv" or die;
                print FH $output,"\n";
            }
        }
        #print "next!! \n";
    }
    die;
#}
die;
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

close(FH);
close(FH_OUT);

sub getLoggingTime {

    my ($sec,$min,$hour,$mday,$mon,$year,$wday,$yday,$isdst)=localtime(time);
    my $nice_timestamp = sprintf ( "%04d%02d%02d%02d%02d%02d",
                                   $year+1900,$mon+1,$mday,$hour,$min,$sec);
    return $nice_timestamp;
}
