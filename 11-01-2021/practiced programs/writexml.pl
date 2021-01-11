use XML::Writer;
use IO::File;
 
my $output = IO::File->new(">output.xml");
 
my $writer = XML::Writer->new(OUTPUT => $output);
$writer->startTag("greeting");
$writer->characters("Hello, world!");
$writer->endTag("greeting");
my $xml = $writer->end();
print $xml;
$output->close();
