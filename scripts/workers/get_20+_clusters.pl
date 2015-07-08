#! /usr/bin/perl -w

=head1 NAME

  get_20+_clusters.pl 

=head1 SYNOPSIS

  get_20+_clusters.pl cdhit-clusterfile 

Options:
 
   none.

=head1 DESCRIPTION

   get all clusters with 20 members 
 
=head1 SEE ALSO

perl.

=head1 AUTHOR

Bonnie Hurwitz E<lt>bhurwitz@email.arizona.eduE<gt>,

=head1 COPYRIGHT

Copyright (c) 2011 Bonnie Hurwitz 

This library is free software;  you can redistribute it and/or modify 
it under the same terms as Perl itself.

=cut


use strict;

my $in  = shift @ARGV;
my $out = shift @ARGV;

open( IN,   $in );
open( OUT,  ">$out.clstr2ct" );
open( OUT2, ">$out.20+.clstr" );

my $curr_clstr;
my $curr_clstr_ct = 0;
my %cluster_to_count;
my %cluster_to_info;
my $first = 0;
while (<IN>) {
    chomp $_;
    if ( $_ =~ /^>/ ) {
        my $clust = $_;
        $clust =~ s/>//;
        $first++;
        if ( $first > 1 ) {
            $cluster_to_count{$curr_clstr} = $curr_clstr_ct;
            $curr_clstr                    = $clust;
            $curr_clstr_ct                 = 0;
        }
        else {
            $curr_clstr = $clust;
        }
    }
    else {
        push( @{ $cluster_to_info{$curr_clstr} }, $_ );
        $curr_clstr_ct++;
    }
}

$cluster_to_count{$curr_clstr} = $curr_clstr_ct;

for my $c ( sort { $cluster_to_count{$b} <=> $cluster_to_count{$a} }
    keys %cluster_to_count )
{
    print OUT "$c\t$cluster_to_count{$c}\n";
    if ( $cluster_to_count{$c} >= 20 ) {
        print OUT2 ">$c\n";
        for my $cc ( @{ $cluster_to_info{$c} } ) {
            print OUT2 "$cc\n";
        }
    }
}
