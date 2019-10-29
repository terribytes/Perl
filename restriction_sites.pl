#!/usr/bin/perl
use strict;
use warnings;
use diagnostics;

# Sequence from the assignment included newline
my $dna = 'AACAGCACGGCAACGCTGTGCCTTGGGCACCATGCAGTACCAAACGGAACGATAGTGAAAACAATCACGA 
ATGACCAAATTGAAGTTACTAATGCTACTGAGCTGGTTCAGAGTTCCTCAACAGGTGAAATATGCGACAG 
TCCTCATCAGATCCTTGATGGAGAAAACTGCACACTAATAGATGCTCTATTGGGAGACCCTCAGTGTGAT 
GGCTTCCAAAATAAGAAATGGGACCTTTTTGTTGAACGCAGCAAAGCCTACAGCAACTGTTACCCTTATG 
ATGTGCCGGATTATGCCTCCCTTAGGTCACTAGTTGCCTCATCCGGCACACTGGAATTTAACAATGAAAG 
CTTCAATTGGACTGGAGTCACTCAAAATGGAATCAGCTCTGCTTGCAAAAGGAGATCTAATAACAGTTTC 
TTTAGTAGATTGAATTGGTTGACCCACTTAAAATTCAAATACCCAGCATTGAACGTGACTATGCCAAACA 
ATGAAAAATTTGACAAATTGTACATTTGGGGGGTTCACCACCCGGGTACGGACAATGACCAAATCTTCCT 
GTATGCTCAAGCATCAGGAAGAATCACAGTCTCTACCAAAAGAAGCCAACAGACTGTAATCCCGAATATC 
GGATCTAGACCCAGAGTAAGGAATATCCCCAGCAGAATAAGCATCTATTGGACAATAGTAAAACCGGGAG 
ACATACTTTTGATTAACAGCACAGGGAATTTAATTGCTCCTAGGGGTTACTTCAAAATACGAAGTGGGAA 
AAGCTCAATAATGAGATCAGATGCACCCATTGGCAAATGCAATTCTGAATGCATCACTCCAAATGGAAGC 
ATTCCCAATGACAAACCATTTCAAAATGTAAACAGGATCACATATGGGGCCTGGCCCAGATATGTTAAGC 
AAAACACTCTGAAATTGGCAACAGGGATGCGAAATGTACCAGAGAAACAAACTAGAGGCATATTTGGCGC 
AATCGCGGGTTTCATAGAAAATGGTTGGGAAGGAATGGTGGATGGTTGGTACGGTTT';

# Remove the newline within string and check if it is removed
$dna =~ s/\s//g;

# Regex for two types of enzymes
## CACNNN/GTG (so CACNNN or CACGTG) where N represents A,C,T, or G
my $site1 = '(CAC[ATGC]{3})';
## GCCWGG, where W represents A or T
my $site2 = '(GCC[AT]{1}GG)';

# Accpet one command line argument that will replace when the user input is DNA sequence and reject if it is not with helpful notification to user
#my $dna = "$ARGV[0]"; # This line will take user input
if ( $dna =~ /[^ATGC]/ig ) {
	die "This is not a DNA sequence. \n";
}

# Call and create subrounties that accept 2 parameters: DNA sequence and a regular expression
print "Looking for pattern 1 = $site1 \n";
find_cut_sites( $dna, $site1 );
print "Looking for pattern 2 = $site2 \n";
find_cut_sites( $dna, $site2 );

sub find_cut_sites {
	my ( $dnaseq, $regex ) = @_; # Subrountine that will accept 2 parameters (DNA sequence and regex)
	while ( $dnaseq =~ /$regex/ig ) { # Matching the regular expression against the sequence
		my $regex_endpos = pos($dnaseq); # End position of dna cut site
		my $regex_length = length($1);
		my $regex_startpos = $regex_endpos - $regex_length + 1; # This is the first position of cut site
		print "$1 matched at residue $regex_startpos","\n";
	}
}

