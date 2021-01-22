use strict;
use warnings;

use XML::Twig;

my $new_file_name = 'new.xml';
my $root = XML::Twig::Elt->new('tax_request');
$root->insert_new_elt('acct_no', '2616');
$root->insert_new_elt('file_root', 'f571fc71717277');
$root->insert_new_elt('log_type', 'FULL');
$root->insert_new_elt('tax_config_set');
$root->insert_new_elt('log_type', 'FULL');
$root->print_to_file($new_file_name);




































