#!/usr/bin/perl
use strict;
use warnings;
use LWP::Simple;
use feature 'say';

## This program is based on NCBI's eutils_example.pl, written by Oleg Khovayko.
## Modified by Chuck 2012, Verena 2016.

open( FASTA, ">", "abstracts.txt" ) or die "Unable to open file: ", $!;
binmode( FASTA, ":utf8" ); # To get the expected output without a "wide character" warning in STDOUT/STDERR

# Basic URL for API call. All E-Utilities calls will start with this.
my $utils = "http://www.ncbi.nlm.nih.gov/entrez/eutils";

# $db indicates which NCBI database to query from.
my $db = "PubMed";

# Query string is in the same format used in Entrez web queries.
my $query = 'alzheimer disease[Title] AND exercise[Title]';

# $report corresponds to the Display Settings in Entrez web queries.
my $report = "text";

# $esearch contains the PATH and parameters for the ESearch call.
my $esearch = "$utils/esearch.fcgi?" . "db=$db&retmax=1&usehistory=y&term=";

# To understand this program better, paste the Esearch call into a browser's address bar.
# What gets displayed?
say "ESearch call: " . $esearch . $query, "\n";

# $esearch_result contains the result of the ESearch call.
my $esearch_result = get( $esearch . $query );

# Results are parsed into three variables: $Count, $QueryKey, and $WebEnv.
$esearch_result =~
m|<Count>(\d+)</Count>.*<QueryKey>(\d+)</QueryKey>.*<WebEnv>(\S+)</WebEnv>|s;
my $Count = $1;
my $QueryKey = $2;
my $WebEnv = $3;

# This area defines a loop which will display $retmax (returned max) results from Efetch
# each time the Enter Key is pressed, after a prompt.
my $retstart = 0;
my $retmax = 100;
my $efetch =
"$utils/efetch.fcgi?" .
"rettype=$report&retmode=text&retstart=$retstart&retmax=$retmax&".
"db=$db&query_key=$QueryKey&WebEnv=$WebEnv";

if ( $Count <= 100 ) {

# Now paste the Efetch call into your browser. What happens this time?
say "EFetch call: " . $efetch;
my $efetch_results = get( $efetch );
say FASTA $efetch_results;
}
else {
say "Too many search results. Narrow your query.";
}

