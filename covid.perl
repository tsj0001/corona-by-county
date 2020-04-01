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
    push @states, "Alabama";
    push @states, "Alaska";
    push @states, "Arizona";
    push @states, "Arkansas";
    push @states, "California";
    push @states, "Colorado";
    push @states, "Connecticut";
    push @states, "Delaware";
    push @states, "District of Columbia";
    push @states, "Florida";
    push @states, "Georgia";
    push @states, "Guam";
    push @states, "Hawaii";
    push @states, "Idaho";
    push @states, "Illinois";
    push @states, "Indiana";
    push @states, "Iowa";
    push @states, "Kansas";
    push @states, "Kentucky";
    push @states, "Louisiana";
    push @states, "Maine";
    push @states, "Maryland";
    push @states, "Massachusetts";
    push @states, "Michigan";
    push @states, "Minnesota";
    push @states, "Mississippi";
    push @states, "Missouri";
    push @states, "Montana";
    push @states, "Nebraska";
    push @states, "Nevada";
    push @states, "New Hampshire";
    push @states, "New Jersey";
    push @states, "New Mexico";
    push @states, "New York";
    push @states, "North Carolina";
    push @states, "North Dakota";
    push @states, "Northern Mariana Islands";
    push @states, "Ohio";
    push @states, "Oklahoma";
    push @states, "Oregon";
    push @states, "Pennsylvania";
    push @states, "Puerto Rico";
    push @states, "Rhode Island";
    push @states, "South Carolina";
    push @states, "South Dakota";
    push @states, "Tennessee";
    push @states, "Texas";
    push @states, "Utah";
    push @states, "Vermont";
    push @states, "Virgin Islands";
    push @states, "Virginia";
    push @states, "Washington";
    push @states, "West Virginia";
    push @states, "Wisconsin";
    push @states, "Wyoming";
    my $csv = Text::CSV->new ({ binary => 1, auto_diag => 1 });
    open my $fh1, "<:encoding(utf8)", "us-states.csv" or die "us-states.csv: $!";
    foreach my $element (@states) {
        open FH, '>>', "${timestamp}/${element}.csv" or die;
        print FH "date",",", "fips",",", "cases",",", "deaths", "\n";
    }
    while (my $row = $csv->getline($fh1)) {
        foreach my $element (@states) {
            if($row->[1] =~ m/$element/) {
                open FH, '>>', "${timestamp}/${element}.csv" or die;
                print FH $row->[0],",", $row->[2],",", $row->[3],",", $row->[4], "\n";
            }

        }
        #if( $row->[2] =~ m/Alabama/) {

        #}

    }
    #open fh2, '>>', "${timestamp}/counties.dat" or die "counties.dat: $!";
    die "success!!!";
}
#open my $fh, "<:encoding(utf8)", "us-counties.csv" or die "us-counties.csv: $!";
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
        #

    }
    foreach my $input (keys %counties) {
        print fh2 $input,"\n";
    }
}


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
    $state = $row->[2];
    my $output = $row->[0] .",". $row->[4];
    my $filename_county = $row->[1] ."-". $row->[2];
    foreach my $element (@counties) {
            #print $element,"  ",$input,"\n";
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
        #print "next!! \n";
}


close(FH);
close(fh2);

sub getLoggingTime {

    my ($sec,$min,$hour,$mday,$mon,$year,$wday,$yday,$isdst)=localtime(time);
    my $nice_timestamp = sprintf ( "%04d%02d%02d%02d%02d%02d",
                                   $year+1900,$mon+1,$mday,$hour,$min,$sec);
    return $nice_timestamp;
}
