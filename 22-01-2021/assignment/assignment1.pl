use strict;
use warnings;
my $url = 'https://en.wikipedia.org/wiki/Perl';
use LWP::Simple;
my $content = get $url;
die "Couldn't get $url" unless defined $content;

my $count = 0;
print"$content\n";
while($content =~ /\bPerl 6\b/g) 
  { 
   $count++;   
  }  
print"number of occurence : $count\n";



