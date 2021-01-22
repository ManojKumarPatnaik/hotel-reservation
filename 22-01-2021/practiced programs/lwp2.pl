use strict;
use warnings;

use LWP::UserAgent;

my $browser = LWP::UserAgent->new;

my $url = 'https://en.wikipedia.org/wiki/Perl';

my $response = $browser->get( $url );
print"content",$response->content; 
my $count = 0;     
 

while($response->content =~ m/Perl/g) 
  { 
    $count++;
  } 
    
print"$count\n";
