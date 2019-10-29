#!/usr/bin/perl
use strict;
use warnings;
use feature 'say';

# Define sequence by calling subrountine loand_sequence
my $sequence = load_sequence("/scratch/Drosophila/dmel-2L-chromosome-r5.54.fasta");

# Define sequence by calling subroutine count_kmers that count kmers of length 15 in the 2L chromosome
my $count_kmers = count_kmers($sequence, 15);

# Define output file
my $output = 'kmers.txt';

# Printing out the result
print_kmers_and_counts($count_kmers, $output);

sub load_sequence {
	my ($file) = @_;
	
	# Create empty string to put the extracting sequence
	my $string = "";
	open (SEQUENCE, "<", $file) or die "Cannot open file $!\n";
	
	# Removing the header
	my $header = <SEQUENCE>;
	while (<SEQUENCE>) {
		chomp;
		$string .=$_;
	}
	close SEQUENCE;
	
	return $string;
}

sub count_kmers {
	my ($sequence, $kmer_length) = @_;
	
	# Create empty hash to put kmer sequence and count the associated number
	my %kmer_count = ();
	for (my $index = 0; $index <= length($sequence) - $kmer_length; $index++) {
		# Extract k-mer of given length
		my $kmer_seq = substr($sequence, $index, $kmer_length);
		
		if (not defined $kmer_count{$kmer_seq}) {
			# Give the sequence initial count of 1 if it is not already found
			my $intial_count = 1;
			$kmer_count{$kmer_seq} = $intial_count;
		}
		else {
			$kmer_count{$kmer_seq} += 1;
		}
	}	
	return \%kmer_count;
}

sub print_kmers_and_counts {
	my($hash_reference, $file_write) = @_;
	open (KMER, ">", $file_write);
	# loop through hash reference and print the results to the output file
	foreach my $key (keys %$hash_reference) {
		say KMER "$key\t$$hash_reference{$key}";
	}
	close KMER;
}
#print $sequence;
## Word count of expected output is 20938309 which is the same as the output

