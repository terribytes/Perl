#!/usr/bin/perl
use strict;
use warnings;
use feature 'say';

# Declaring a variable to hold the default sequence
my $dna = "AATGGTTTCTCCCATCTCTCCATCGGCATAAAAATACAGAATGATCTAACGAA";

# Check if user provide DNA sequence or else return a error message
if ( $ARGV[0] ) {
	my $input = $ARGV[0];
	if ( $input =~ /[^ATGC]/gi ) {
		die "This is not a valid sequence.Try again. \n";
	}
	else {
		$dna = $input;
	}
}

# Print helpful message for the user about the sequence that will be analyzed
say "Input sequence: $dna";
print " \n";
# Calling the subrountine if the input is dna sequence
if ( $dna =~ /GT.*AG/ig ) {
	find_introns( $dna );
}
else {
	say "No potential introns were found.";
}

sub find_introns {
	my ( $dna) = @_;
	while ( $dna =~ /(GT(.*)AG)/ig ) {
		my $intron = $1; # Intron start with GT and end with AG (outer group)
		my $input = $2; # Checking if there are child nodes left to traverse
		find_introns($input);
		say "Potential intron: $intron";
	}
}
