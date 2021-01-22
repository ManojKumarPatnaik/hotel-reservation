use XML::Writer;
use IO::File;
 
my $output = IO::File->new(">assignment3.xml");
 
my $writer = XML::Writer->new(OUTPUT => $output);
$writer->startTag("tax_request");
$writer->startTag("acct_no");
$writer->characters("2616");
$writer->endTag("acct_no");
$writer->startTag("file_root");
$writer->characters("f571fc71717277");
$writer->endTag("file_root");
$writer->startTag("log_type");
$writer->characters("FULL");
$writer->endTag("log_type");
$writer->startTag("tax_config_set");
$writer->startTag("tax_config");
$writer->startTag("tax_config_row");
$writer->startTag("config_name");
$writer->characters("TaxwareEnterpriseURL");
$writer->endTag("config_name");
$writer->startTag("config_val");
$writer->characters("https://partner.taxware.net/Twe/api/rest/calcTax/doc");
$writer->endTag("config_val");
$writer->endTag("tax_config_row");
$writer->startTag("tax_config_row");
$writer->startTag("config_name");
$writer->characters("addrTypes");
$writer->endTag("config_name");
$writer->startTag("config_val");
$writer->characters("sT lSP lU sF bT");
$writer->endTag("config_val");
$writer->endTag("tax_config_row");
$writer->startTag("tax_config_row");
$writer->startTag("config_name");
$writer->characters("hmac_key");
$writer->endTag("config_name");
$writer->startTag("config_val");
$writer->characters("058faf36-0e27-46c4-bea0-04a34fe5bcda");
$writer->endTag("config_val");
$writer->endTag("tax_config_row");
$writer->endTag("tax_config");
$writer->startTag("doc_origin_dest_address");
$writer->startTag("bill_to_address");
$writer->startTag("address_seq");
$writer->characters("13210");
$writer->endTag("address_seq");
$writer->startTag("tax_eng_specific_id");
$writer->characters("13210");
$writer->endTag("tax_eng_specific_id");
$writer->emptyTag("company_name");
$writer->startTag("address1");
$writer->characters("350 5th Ave");
$writer->endTag("address1");
$writer->emptyTag("address2");
$writer->emptyTag("address3");
$writer->startTag("city");
$writer->characters("New York");
$writer->endTag("city");
$writer->startTag("state");
$writer->characters("NY");
$writer->endTag("state");
$writer->startTag("zip");
$writer->characters("10118");
$writer->endTag("zip");
$writer->startTag("country");
$writer->characters("US");
$writer->endTag("country");
$writer->emptyTag("locality");
$writer->startTag("geo_code");
$writer->characters("0");
$writer->endTag("geo_code");
$writer->endTag("bill_to_address");
$writer->startTag("ship_to_address");
$writer->startTag("address_seq");
$writer->characters("13210");
$writer->endTag("address_seq");
$writer->startTag("tax_eng_specific_id");
$writer->characters("13210");
$writer->endTag("tax_eng_specific_id");
$writer->emptyTag("company_name");
$writer->startTag("address1");
$writer->characters("350 5th Ave");
$writer->endTag("address1");
$writer->emptyTag("address2");
$writer->emptyTag("address3");
$writer->startTag("city");
$writer->characters("New York");
$writer->endTag("city");
$writer->startTag("state");
$writer->characters("NY");
$writer->endTag("state");
$writer->startTag("zip");
$writer->characters("10118");
$writer->endTag("zip");
$writer->startTag("country");
$writer->characters("US");
$writer->endTag("country");
$writer->emptyTag("locality");
$writer->startTag("geo_code");
$writer->characters("0");
$writer->endTag("geo_code");
$writer->endTag("ship_to_address");
$writer->endTag("doc_origin_dest_address");
$writer->endTag("tax_config_set");
$writer->endTag("tax_request");
my $xml = $writer->end();
print $xml;
$output->close();













