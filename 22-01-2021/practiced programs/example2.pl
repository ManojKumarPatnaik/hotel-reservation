use strict;
use warnings;

use XML::Smart;

my $XML = XML::Smart->new() ;

$XML->{tax_request} = 
{
 acct_no => '2616',
 file_root => 'f571fc71717277',
 log_type => 'FULL'
 
} ;

$XML->save('new.xml') ;
