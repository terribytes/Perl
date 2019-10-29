#!/usr/bin/perl
use strict;
use warnings;
use feature 'say';

# Author: C Roesel modified by T Shen
# Creation Date: November 15 2013
# Modification Date: December 5 2018 

open ( GFF3, ">", 'crispr.gff3' ) or die $!;
open ( TXT, ">", 'off_targets.txt' ) or die $!;
blastOligos("unique_kmers.fasta", "Drosophila2L");

close GFF3;
close TXT;

sub blastOligos {
	my ($input, $db) = @_;
	# Put my BLAST command and all the params in an array. This could be created as a single string, but an array makes it easier to see the individual parameters.
	my @command = ('blastn', '-task blastn', '-db '.$db, '-query '.$input, '-outfmt 6');

 	# Print the BLAST command for debugging purposes.
	print "@command\n";

  	# Run the BLAST command and get the output as a filehandle named BLAST.
  	open( BLAST, "@command |" );

	# Process the BLAST output line-by-line using the filehandle BLAST.
  	while (my $blast = <BLAST>) { 
	
		# Get rid of end-of-line characters.
		chomp $blast;

      	processBlastOutputLine($blast) if $blast !~ /^#/;
  }
}

sub processBlastOutputLine {
	my ($blastOutputLine) = @_;

     	 # Assign the column positions to meaningfully named variables.
      	my ($queryId, $chrom, $identity, $length, $mismatches, $gaps, $qStar, $qEnd, $start,$end) = split("\t", $blastOutputLine);
	
	local $, = "\t";
	
	if ($identity == 100) {
      		my $strand   = '+';
      		my $gffStart = $start;
      		my $gffEnd   = $end;
	
	if ($start > $end) {
          	$strand   = '-';
          	$gffStart = $end;
          	$gffEnd   = $start;
      	}
	
      	my @rowArray = ($chrom, ".", 'OLIGO', $gffStart, $gffEnd, ".", $strand, ".", "Name=$queryId;Note=Some info on this oligo");
      	print GFF3 @rowArray, "\n";
  	}

	else {
		print TXT $blastOutputLine, "\n";
	}
}
