package Choice;


sub new {
         my $class = shift;
         my $self = {
                     choice => shift                     
                    };

        bless($self,$class);

        return $self;
}
sub test
{ 
 my ($self) = @_;
 my $input = $self->{'choice'}; 
 if($input == 1 or $input == 2)
 { 
   print"thank you \n"; 
 }
 else
 {
  print"enter either 1 or 2\n";
  goto INPUT;
 }
}



1;


