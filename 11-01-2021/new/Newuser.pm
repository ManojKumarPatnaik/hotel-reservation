package Newuser;

sub new {
         my $class = shift;
         my $self = {
                     userdata => shift,
                     database=>shift
                   };

        bless($self,$class);

        return $self;
        }
        

sub username_verification
{
 my ($self) = @_;
 my $name = $self->{'userdata'};  
 my $dbh = $self->{'database'};
 if ($name =~  /^[A-Za-z]+$/)
  {    
    my $sth = $dbh->prepare("SELECT name FROM users WHERE name = '$name'");
    $sth->execute();
    my @name_db = $sth->fetchrow_array() ; 
     my $flag = 0;
     my $len = scalar(@name_db);
     for(my$i=0;$i<$len;$i++)
     {
      if($name =~ $name_db[$i])
      {
       $flag = $flag+1;
      }
     }
     if($flag>=1)
     {
       print"username Already exist\n";
       print"enter a unique username :\n";
       goto USERNAME;
     }
     else
     {
      return $name;
      print"Enter a valid email\n";
      goto EMAIL;
     } 
   }
  else
   {
     print"user name should be alphabets\nRe-enter the username\n";
     goto USERNAME;
   }   
}


sub email_verification
{
my ($self) = @_;
my $email = $self->{'userdata'}; 
if ( $email =~ /([a-zA-Z]+)\@([a-zA-Z]+)\.(com)/)
   {
    return $email;
    print"Enter the phone number:\n";
    goto PHNO;    
   }
   else
   {
    print"invalid email\n Re-enter a valid emailID\n";
    goto EMAIL;
   }

}

sub phno_verification
{
my ($self) = @_;
my $phno = $self->{'userdata'}; 
my $dbh = $self->{'database'};
if ($phno=~/^[789][0-9]{9}$/)
    { 
     my $sth = $dbh->prepare("SELECT phno FROM users WHERE phno = '$phno'");
    $sth->execute();
     my @phone_db = $sth->fetchrow_array() ; 
     my $flag = 0;
     my $len = scalar(@phone_db);
     for(my$i=0;$i<$len;$i++)
     {
      if($phno =~ $phone_db[$i])
      {
       $flag = $flag+1;
      }
     }
     if($flag>=1)
     {
       print"phone number Already exist\n";
       print"register using new phone number :\n";
       goto PHNO;
     }
     else
     {
      return $phno;
      print"enter the password:\n";
      goto PASSWORD;
     }
      
    }
    else
    {
     print"invalid number\nRe-enter a valid phone no:\n";
     goto PHNO;
    }
}
   
sub password_verification
{
my ($self) = @_;
my $password = $self->{'userdata'}; 
 my $len = length($password);
    if( $len >= '8' && $password =~ /\d/ && $password =~ /[a-z]/ && $password =~ /[A-Z]/ && $password =~ /[^A-Za-z0-9]/
    && $password=~/[!#$%&:;<=>?@[\\\]^_{|}~]/)
    {
     return $password;
     print"details entered\n"; 
    }  
    else
    {
      print"Password should contain atleast 8 characters and contain both upperandlowercase alphabets , numbers and symbols \nRe-enter the password\n";
      goto PASSWORD;
    }
} 

   
1;

