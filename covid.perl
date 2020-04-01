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
my $getstates;
my $timestamp = ".";
#my $aoa = csv (in => "us-counties.csv");


#csv (in => $aoa, out => "file.csv", sep_char=> ";");


GetOptions(
    'state=s' => \$state,
    'county=s' => \$county,
    'usefile' => \$usefile,
    'getcounties' => \$getcounties,
    'getstates' => \$getstates
) or die "Usage: $0 --STATE\n";

if($getstates) {
    $timestamp = getLoggingTime();
    mkdir "${timestamp}" or die "peepee";
    my @states;
    open(FH, '<', 'states.dat') or die $!;
    while(<FH>) {
        chomp($_);
        print $_,"\n";
        push @states, $_;
    }
    my $csv = Text::CSV->new ({ binary => 1, auto_diag => 1 });
    open my $fh1, "<:encoding(utf8)", "us-states.csv" or die "us-states.csv: $!";
    foreach my $element (@states) {
        open FH, '>>', "${timestamp}/${element}.csv" or die;
        print FH "date",",", "cases",",", "deaths", "\n";
    }
    while (my $row = $csv->getline($fh1)) {
        foreach my $element (@states) {
            if($row->[1] =~ m/$element/) {
                open FH, '>>', "${timestamp}/${element}.csv" or die;
                print FH $row->[0],",", $row->[3],",", $row->[4], "\n";
            }
        }
    }
    die "success!!!";
}

if($getcounties) {
    $timestamp = getLoggingTime();
    mkdir "${timestamp}" or die "peepee";
    my %counties;
    my $csv = Text::CSV->new ({ binary => 1, auto_diag => 1 });
    open my $fh1, "<:encoding(utf8)", "us-counties.csv" or die "us-counties.csv: $!";
    open fh2, '>>', "${timestamp}/counties.dat" or die "counties.dat: $!";
    while (my $row = $csv->getline($fh1)) {
        #if( $row->[2] =~ m/Alabama/) {
            $input = $row->[1] .",". $row->[2];
            $counties{$input} = 1;
            $state = $row->[2];
            mkdir "${timestamp}/${state}";
        #}
    }
    foreach my $input (keys %counties) {
        print fh2 $input,"\n";
    }
}
my @counties;
my $csv = Text::CSV->new ({ binary => 1, auto_diag => 1 });
open fh2, "<:encoding(utf8)", "${timestamp}/counties.dat" or die "counties.dat: $!";
while(<fh2>) {
    chomp($_);
    push @counties, $_;
}
open my $fh2, "<:encoding(utf8)", "us-counties.csv" or die "us-counties.csv: $!";
while (my $row = $csv->getline($fh2)) {
    $input = $row->[1] .",". $row->[2];
    $state = $row->[2];
    my $output = $row->[0] .",". $row->[4];
    my $filename_county = $row->[1] ."-". $row->[2];
    foreach my $element (@counties) {
        if($input =~ m/$element/) {
            if($getcounties) {
                open FH, '>>', "${timestamp}/${state}/${filename_county}.csv" or die;
            }
            else {
                open FH, '>>', "${filename_county}.csv" or die;
            }
            print FH $output,"\n";
        }
    }
}
close(FH);
close(fh2);
sub getLoggingTime {
    my ($sec,$min,$hour,$mday,$mon,$year,$wday,$yday,$isdst)=localtime(time);
    my $nice_timestamp = sprintf ( "%04d%02d%02d%02d%02d%02d",
                                   $year+1900,$mon+1,$mday,$hour,$min,$sec);
    return $nice_timestamp;
}
