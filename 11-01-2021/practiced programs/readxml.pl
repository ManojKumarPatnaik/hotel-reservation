#!/usr/bin/perl

use strict;
use warnings;

use XML::LibXML;

my $filename = 'menu.xml';

my $dom = XML::LibXML->load_xml(location => $filename);

foreach my $recepie ($dom->findnodes('//food')) {
    print "dish name : " , $recepie->findvalue('name'),"\n";
     print 'price :', $recepie->findvalue('price'),"\n";
}
