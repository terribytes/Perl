#!/usr/bin/perl
use strict;
use warnings;
use diagnostics;

# Direct path to the fasta file
my $fasta = '/scratch/SampleDataFiles/test.fasta'; 

# Open the fasta file
open ( FASTA, "<", $fasta ) or die "cannot read: ", $!;

# Set the local seperator to > before reading it so that we can read the file in one line.
local $/ = ">";

# Declare variables for:
## 1) Number of sequences with hydrophobic region, using to count the hydrophobic regions
my $hydrophobic_count = 0;
## 2) Total number of sequences found in the file, using to count the total sequence region
my $total_count = 0;

# Declare regexs for:
## 1) Hydrophobic regions
my $hydrophobic = "([VILMFWCA]{8,})"; # a stretch of 8 or more amibo acids 
## 2) The header
my $header = "([A-Z].*;)";
## 3) ALl documents $1(headers) $2(sequence)
my $all = "([A-Z].*;)\n(.*)";

# Read the file and capture headers that matahcd the hydrophobic regions
while ( <FASTA> ) {
	# Capture the header and dna sequence by regex
	if ( /$all/ ) {
		my $header = $1;
		my $dna = $2;
		$total_count++;
	# Find only the matched hydrophobic header and dna sequence 
		if ( /$hydrophobic/ ) {
			$hydrophobic_count++;
			print "Hydrophobic region found in $header \n";
			find_motif( $dna, $hydrophobic );
			print "\n";
		}
	}
}
print "Hydrophobic region(s) found in $hydrophobic_count sequence out of $total_count sequences \n";

# Create a subroutine to find the position of hydrophobic region
sub find_motif {
	my ( $dna, $hydrophobic ) = @_;
		while ( $dna =~ /$hydrophobic/g ) {
			my $seq_endpos = pos($dna);
			my $seq_length = length($1);
			my $seq_startpos = $seq_endpos - $seq_length + 1;
			print "$1 found at $seq_startpos \n";		
		}
}
