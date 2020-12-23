#!/usr/bin/perl

use strict;
use warnings;
use lib '/home/ajith/perl5/lib';
use Login;
use DBI;
my $username;
my $email;
my $phno;
my $password;

#first page

START:print "Hotel Reservation system\n";
print "\n1.Login\n";
print "2.Register(new user)\n";

#selecting whether new or old user 

print"enter either 1 or 2\n";
INPUT:my $input = <STDIN>;
if($input == 1 or $input == 2)
{ 
   print"thank you \n"; 
}
else
 {
print"enter either 1 or 2\n";
  goto INPUT;
  }

#registration
 my $dbh = DBI->connect("dbi:mysql:dbname=hotel;host=localhost",'ajith', 'Aspire@123') || die "Could not connect to database: $DBI::errstr";
if($input == 2)
{
  print "Hotel Reservation system\n";
  print "\nRegister\n"; 
  
  #username validation
  
  print"Enter the username \n";
  USERNAME:$username = <STDIN>;
  
  if ($username =~  /^[A-Za-z]+$/)
   {
    my $sth = $dbh->prepare("SELECT name FROM users WHERE name = '$username'");
    $sth->execute();
    my @name_db = $sth->fetchrow_array() ; 
     my $flag = 0;
     my $len = scalar(@name_db);
     for(my$i=0;$i<$len;$i++)
     {
      if($username =~ $name_db[$i])
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
      print"Enter the emailId:\n";
      goto EMAIL;
     }
     
   }
   else
   {
     print"user name should be alphabets\nRe-enter the username\n";
     goto USERNAME;
   }

   #email validation
   
   EMAIL:$email = <STDIN>;
   if ( $email =~ /([a-zA-Z]+)\@([a-zA-Z]+)\.(com)/)
   {
    print"Enter the phone number:\n";    
   }
   else
   {
    print"invalid email\n Re-enter a valid emailID\n";
    goto EMAIL;
   }
    
    #phone number validation
    
    PHNO:my $phno = <STDIN>;
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
      print"enter the password:\n";
      goto PASSWORD;
     }
      
    }
    else
    {
     print"invalid number\nRe-enter a valid phone no:\n";
     goto PHNO;
    }
    
    #password verification
    
    PASSWORD:$password = <STDIN>;
    my $len = length($password);
    if( $len >= '8' && $password =~ /\d/ && $password =~ /[a-z]/ && $password =~ /[A-Z]/ && $password =~ /[^A-Za-z0-9]/
    && $password=~/[!#$%&:;<=>?@[\\\]^_{|}~]/)
    {
      my $sth = $dbh->prepare("SELECT password FROM users WHERE password = '$password'");
      $sth->execute();
      my @pass_db = $sth->fetchrow_array() ; 
      my $flag = 0;
      my $len = scalar(@pass_db);
      for(my$i=0;$i<$len;$i++)
      {
       if($password =~ $pass_db[$i])
       {
        $flag = $flag+1;
       }
      }
      if($flag>=1)
      {
       print"password already exist\n";
       print"enter a unique password :\n";
       goto PASSWORD;
      }
      else
      {
       print"password entered\n";
      }
      
    }
    
    else
    {
      print"Password should contain atleast 8 characters and contain both upperandlowercase alphabets , numbers and symbols \nRe-enter the password\n";
      goto PASSWORD;
    }


    #giving the registration details to database
    my $info1 = new Register($username,$email,$phno,$password);
    $info1->database();
    }


#login 

 if($input == 1)
 {
  print"Login\n";
  NAME:print"enter the registered Username : ";
  my $usname = <STDIN>;
 
  PASS:print"\nenter the password : ";
  my$pass = <STDIN>;
 
  
  PNO:print"\nenter the registered Phone no : ";
  my$phone = <STDIN>;

  #giving the login details to login function
  my $info2 = new Login($usname,$pass,$phone);
  $info2 -> login();
}





