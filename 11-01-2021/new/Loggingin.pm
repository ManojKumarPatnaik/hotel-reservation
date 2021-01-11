package Loggingin;

sub new {
         my $class = shift;
         my $self = {
                     username => shift,
                     password => shift,
                     phone => shift, 
                     database=>shift                   
                    };

        bless($self,$class);

        return $self;
        }

#login function

sub login
{
  my ($self) = @_;
  my $name = $self->{'username'}; 
  my $password = $self->{'password'};
  my $phno = $self->{'phone'};
  my $dbh = $self->{'database'};

#username verification  
  my $sth = $dbh->prepare("SELECT password FROM users WHERE name = '$name'");
  $sth->execute();
  my $pass_db = $sth->fetchrow_array() ; 
  if($pass_db eq '')
  {
   print "invalid username\n";
   goto NAME;
  } 
  
  
#password verification
  my $sth = $dbh->prepare("SELECT all name FROM users WHERE password = '$password'");
  $sth->execute();
  my @name_db = $sth->fetchrow_array();
     my $flag = 0;
     my $len = scalar(@name_db);
     for(my$i=0;$i<$len;$i++)
     {
      if($name =~ $name_db[$i])
      {
       $flag = $flag+1;
      }
     }
     if($flag = 1)
     {
       print"thank you\n";
     }
     else
     {
      print"invalid password\n";
      goto PASSWORD;
     }
 
  
#phone number verification
  my $sth = $dbh->prepare("SELECT phno FROM users WHERE password = '$password' and name = '$name'");
  $sth->execute();
  my $phno_db = $sth->fetchrow_array() ;
  if($phno_db eq '')
  {
   print "invalid username or password\n";
   goto NAME;
  }
  elsif($phno_db ne $phno)
  {
   print"Invalid phone number\n";
   goto PNO;
  }   
  if ($name =~ $name_db  && $password =~ $pass_db && $phno =~ $phno_db) 
  {
  goto KEY;
  }
  else
  {
   print"invalid login credentials\n";
   goto START;
  } 
  
}  
  
1;  
  
