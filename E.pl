#!/usr/bin/perl

use strict;
use warnings;
use lib '/home/ajith/perl5/lib';
use Ei;
my $username;
my $email;
my $phno;
my $password;

#first page

print "Hotel Reservation system\n";
print "\n1.Login\n";
print "2.Register(new user)\n";


my $input = <STDIN>;

if($input == 2)
{
print "Hotel Reservation system\n";
print "\nRegister\n";

print"Enter the username \n username : ";
$username = <STDIN>;
if ( $username =~  /[a-z]/ && $username =~ /[A-Z]/)
{
print"Enter the emailId\n";    
}
else
{
die"user name should only alphabets\n";
}

print"Enter the email ID\n email ID : ";
$email = <STDIN>;
if ( $email =~ /([a-zA-Z]+)\@([a-zA-Z]+)\.(com)/)
{
print"Enter the phone number\n";    
}
else
{
die"Enter a valid email\n";
}
print" ph no : "; $phno = <STDIN>;
my @phno = split("",$phno);
if (length($phno)==10 && $phno[0] =~ m/7/ or$phno[0] =~ m/8/ or $phno[0] =~ m/9/)
{
print"enter the password\n";
}
else
{
die"Enter a valid number\n";
}
print" password :";
$password = <STDIN>;
if(length($password)<=8)
{
die"Password should contain atleast 8 charecters";
}
if ($password =~ /\d/ && $password =~ /[a-z]/ && $password =~ /[A-Z]/ && $password =~ /[^A-Za-z0-9]/)
{
print"Registered sucessfully\n";
}
else
{
die"your password should contain both upperandlowercase alphabets , numbers and symbols\n";
}

use DBI;
my $info1 = new E($username,$email,$phno,$password);
$info1->database();
}

if($input == 1)
{
print"Login\n";
print"Username : ";
chomp(my $usname = <STDIN>);
print"\npassword : ";
chomp(my $pass = <STDIN>);

my $info2 = new Ei($usname,$pass);
$info2 -> login()
}





