#!/usr/bin/perl

use strict;
use warnings;
use lib '/home/ajith/perl5/lib';
use Login;
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

if($input == 2)
{
  print "Hotel Reservation system\n";
  print "\nRegister\n"; 
  
  #username validation
  
  print"Enter the username \n";
  USERNAME:$username = <STDIN>;
  
  if ($username =~  /^[A-Za-z]+$/)
   {
    print"Enter the emailId:\n";    
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
      print"enter the password:\n";
    }
    else
    {
     print"invalid number\nRe-enter a valid phone no:\n";
     goto PHNO;
    }
    
    #password verification
    
    PASSWORD:$password = <STDIN>;
    my $len = length($password);
    print"$len\n";
    if( $len >= '8' && $password =~ /\d/ && $password =~ /[a-z]/ && $password =~ /[A-Z]/ && $password =~ /[^A-Za-z0-9]/
    && $password=~/[!#$%&:;<=>?@[\\\]^_{|}~]/)
    {
        print"Registered sucessfully\n";
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
  $info2 -> login()
}





