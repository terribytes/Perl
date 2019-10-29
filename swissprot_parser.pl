#!/usr/bin/perl
use strict;
use warnings;
use diagnostics;

# Direct path to the SwissProt file
my $swissprot = '/scratch/SampleDataFiles/example.sp';

# Set the record seprator to // according to Swissprot format
local $/ = "//";

# Regexs for AC, OS, OX, ID, GN, SQ
my $AC = "AC((.*?;)(.*?));";
my $OS = "OS(.*?)\\."; 
my $OX = "OX(.*?;)";
my $ID = "PRT;(.*?AA)";
my $GN = "GN(.*?\\.)";
my $SQ = "SQ.*;(.*)";

# Reading the file
open ( SWISSPROT, "<", $swissprot );

# Declare a variable to store parsed file and start reading it from SwissProt file
my $read = "";
while ( <SWISSPROT> ) {
        chomp;
        $read = $read . $_;
}

# Create fasta file to write with annotation lines
open ( WRITE, ">", "ceru_human.fasta" );

# Finding the pattern using subrountine
sub find_pattern {
	my ( $read, $pattern ) = @_;
	if ( $read =~ /$pattern/s ) { # Using /s so it can read multiline
		return $1;
	}
	else {
		return "error\n";
	}
}

# Writing the first line include all AC, OS, OX, ID, GN informtation
print WRITE ">", find_pattern( $read, $AC ), " | ";
print WRITE find_pattern( $read, $OS ), " | ";
print WRITE find_pattern( $read, $OX ), " | ";
print WRITE find_pattern( $read, $ID ), " | ";
print WRITE find_pattern( $read, $GN ), " \n";
 
# Writing the SQ information by removing the spaces and new line character from SwissProt file than print it
my $seq = find_pattern( $read, $SQ );
$seq =~ s/\n//g;
$seq =~ s/ //g;
print WRITE $seq, "\n";

# Close files
close SWISSPROT;
close WRITE;
