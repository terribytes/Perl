#!/usr/bin/perl
use strict;
use warnings;
use feature 'say';

# Declare a DNA sequence
my $dna = "AATGGTTTCTCCCATCTCTCCATCGGCATAAAAATACAGAATGATCTAACGAA";

# Checking is the user inpur is DNA sequence
if ( $ARGV[0] ) {
	my $input = $ARGV[0];
	if ( $input =~ /[^ATGC]ig/ ) {
		die " This is not a valid sequence. Try again. \n";
	}
	else {
		$dna = $input;
	}
}

# Print the input sequence or the sequence that will be analyzed
say "Input sequence: $dna";
find_coding_regions($dna);

sub find_coding_regions {	
	my ( $dna ) = @_;
	while ( $dna =~ /((ATG)(\w*)(TAG|TAA|TGA))/g ) {
		my $all = $1;
		my $start = $2;
		my $middle = $3;
		my $end = $4;
		my $left = $start.$middle;
		my $right = $middle.$end;
		find_coding_regions($left);
		find_coding_regions($right);
		say "Potential coding region: $all";
	}
}
