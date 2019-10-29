#!/usr/bin/perl
use strict;
use warnings;
use diagnostics;
use feature 'say';

# Define sequence by calling subrountine loand_sequence
my $sequence = load_sequence('/scratch/Drosophila/dmel-2L-chromosome-r5.54.fasta');

# Define sequence by calling subroutine count_kmers that count kmers of length 23 in the 2L chromosome
my $kmer_length = 23;
my $kmer = count_kmers($sequence, $kmer_length);

# Define output file and print it out
my $output = 'unique_kmers.fasta';
print_kmers_to_fasta($kmer, $output);


# Open FASTA file, read lines, and remove header
sub load_sequence {
	my ($file) = @_;
	
	# Store extract into this empty string
	my $sequence = "";
	
	# Open the file or else close it
	open ( FASTA, "<", $file ) or die "Cannot open file $!";
	local $/ = ">";

	# Loop through line by line by line and only store non header line
	while (<FASTA>) {
		chomp; # Remove end of line character
		if( /.*?$(.*)/ms ) {
		$sequence .= $1; # Add sequence together
		$sequence =~ s/\s//g; # Remove white spaces
		}
	}
	close FASTA;
	return \$sequence;
}

sub count_kmers {
	my ($sequence, $kmer_length) = @_;
	
	# Declare empty hash
	my %kmer_count = ();
	
	# The moving start position is 0 and it will keep going untill it goes to the end of the file, window will increase in 1 increment	
	for (my $index = 0; $index < (length($$sequence) - $kmer_length); $index ++) {
		# Extract k-mer of given length
		my $kmer_seq = substr($$sequence, $index, $kmer_length);
			# Continue if sequence ends with nucleotides GG
		if ( $kmer_seq =~ /([ATGC]{21}GG)/ ) {
			$kmer_count{$kmer_seq}++;
		}
	}	
	return (\%kmer_count);
}

sub print_kmers_to_fasta {
	my($ref, $file_write) = @_;
	open (KMER, ">", $file_write) or die "Cannot open file $!";
	
	my $index = 1;
	
	# loop through hash reference and print the results to the output file
	foreach my $kmer_key (keys $ref) {
		if ($ref->{$kmer_key} == 1){
			say KMER ">crispr_$index";
			say KMER "$kmer_key";
			$index++;
			if ($index >= 1001){
				return;
			}
		}
	}
	close KMER;
}

