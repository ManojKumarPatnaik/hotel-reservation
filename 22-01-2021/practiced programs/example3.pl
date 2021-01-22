use strict;
use warnings;
use XML::LibXML;



my $doc = XML::LibXML::Document->new();

my $root = $doc->createElement('tax_request');


my %tags = (
    acct_no => '2616',
    file_root => 'f571fc71717277',
    log_type => 'FULL',    
    
);

for my $name (keys %tags) {
    my $tag = $doc->createElement($name);
    my $value = $tags{$name};
    print"$value\n";
    $tag->appendTextNode($value);
    $root->appendChild($tag);
    
}

$doc->setDocumentElement($root);
print $doc->toString();

