use strict;
use warnings;

use XML::LibXML;

my $filename = 'assignment.xml';

my $dom = XML::LibXML->load_xml(location => $filename);


#sub-division 1 and 2
foreach my $recepie ($dom->findnodes('//tax_request')) 
{
    print "account no : " , $recepie->findvalue('acct_no'),"\n";
    print "method name : " , $recepie->findvalue('method_name'),"\n";
}

#sub-division 3
foreach my $recepie ($dom->findnodes('//tax_config_row')) 
{
    print "config names : " , $recepie->findvalue('config_name'),"\n";
    print "config values : " , $recepie->findvalue('config_val'),"\n";
}

#sub-division 4
foreach my $recepie ($dom->findnodes('//bill_from_location')) 
{
    print "service_location_no : " , $recepie->findvalue('service_location_no'),"\n";
    print "service_location_name : " , $recepie->findvalue('service_location_name'),"\n"; 
    print "client_service_location_id : " , $recepie->findvalue('client_service_location_id'),"\n";
    print "tax_eng_specific_id: " , $recepie->findvalue('tax_eng_specific_id'),"\n";
    print "company_name: " , $recepie->findvalue('company_name'),"\n";
    print "Addres1 : " , $recepie->findvalue('address1'),"\n";
    print "City : " , $recepie->findvalue('city'),"\n";
    print "State : " , $recepie->findvalue('state'),"\n";
    print "country : " , $recepie->findvalue('country'),"\n";
    print "Zip code : " , $recepie->findvalue('zip'),"\n";
    print "Geo code : " , $recepie->findvalue('geo_code'),"\n";
  
}

#sub-division 5
foreach my $recepie ($dom->findnodes('//tax_group_config_row')) 
{
    print "config names : " , $recepie->findvalue('config_name'),"\n";
    print "config values : " , $recepie->findvalue('config_value'),"\n";
}

  



















