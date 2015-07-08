#! /usr/bin/perl -w

# filter by size script

use strict;
use Bio::Seq;
use Bio::SeqIO;

 if ( @ARGV != 2 ) { die "Usage: filter_by_size.pl input.fa output.fa\n"; }

   my $input  = shift @ARGV;
   my $output = shift @ARGV;

   my $seqin  = Bio::SeqIO->new( '-format' => 'Fasta', -file => $input );
   my $seqout = Bio::SeqIO->new( '-format' => 'Fasta', -file => ">$output" );

 while ( ( my $seqobj = $seqin->next_seq() ) ) {

   # check seq length
   my $sequence = $seqobj->seq();
   my $length   = length($sequence);

   if ( $length >= 60 ) {
      $seqout->write_seq($seqobj);
                        }
   }
