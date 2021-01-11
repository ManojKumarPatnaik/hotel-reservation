#!/usr/bin/perl
use strict;
use warnings;
use lib '/home/ajith/perl5/lib';
use Choice;
use Newuser;
use Loggingin;
#first page
use Database;
use Dateverification;
use Roomverification;
use Date::Simple qw/date/;
use Date::Range;
use Modify;
use Search;
use Cancel;
my $db = Database->DB_connect();

START:print "Hotel Reservation system\n";
print "\n1.Login\n";
print "2.Register(new user)\n";

print"enter either 1 or 2\n";
INPUT:my $input = <STDIN>;
my $info2 = new Choice($input);
$info2 -> test();
my $emailid;
#registeration 
if($input == '2')
{
  print"Enter the username\n";
  USERNAME: my $username = <STDIN>;
  my $name = new Newuser($username,$db);
  $name -> username_verification(); 
  
  print"Enter the email\n";
  EMAIL: $emailid = <STDIN>;
  my $email = new Newuser($emailid);
  $email -> email_verification();

  print"Enter the phone number\n";
  PHNO: my $phnum = <STDIN>;
  my $phno = new Newuser($phnum,$db);
  $phno -> phno_verification();

  print"Enter the password\n";
  PASSWORD: my $pass = <STDIN>;
  my $password = new Newuser($pass);
  $password -> password_verification();
 
  my $details = new Database($username,$emailid,$phnum,$pass,$db);
  $details -> register(); 
  
  
}
if($input == '1')
{
  print"Login\n";
  NAME:print"enter the registered Username : ";
  my $usname = <STDIN>;
 
  PASS:print"\nenter the password : ";
  my$pass = <STDIN>;
 
  
  PNO:print"\nenter the registered Phone no : ";
  my $phone = <STDIN>;

  #giving the login details to login function
  my $info2 = new Loggingin($usname,$pass,$phone,$db);
  $info2 -> login();
  
  #page displayed after login 
  KEY:print"Welcome!\n";
  print"Menu\n";
  print"1.New book\n";
  print"2.my booking\n";
  print"3.logout\n";
  print"4.modify booking\n";
  print"5.search\n";
  print"6.cancel booking\n";
   
 #selction options
  print"Enter a key\n";
  my $key = <STDIN>;
  if($key !~ /^[1-6]$/)
  {
   print"Enter a valid key\n";
   goto KEY;
  }
  my $check_in_date;
  my $check_out_date;
  my $nop;
  my $sel_room;
  my $duration;
  my $total_rate;
  if($key == 1)
  {
   #getting check in date
    CID:print"check in date(yyyy-mm-dd) :\n";
    chomp( $check_in_date = <STDIN>);
    my $cid = new Dateverification($check_in_date);
    $cid -> check_in_date();
    #getting check out date
    COD:print"check out date(yyyy-mm-dd) :\n";
    chomp( $check_out_date = <STDIN>);
    my $cod = new Dateverification($check_out_date);
    $cod -> check_out_date();    
    NOP:print"enter number of persons(Max 3 persons per room) :\n";
    chomp( $nop = <STDIN>);
    if($nop =~ /^[1-3]$/)
     {
      print "Thank you\n";
     }
    else
     {
      print"minimum 1 and maximum 3 members per room\n";
      goto NOP;
     }
     
    my $dates_ok = new Roomverification($check_in_date,$check_out_date,$db);
    $dates_ok -> room_book();
    print"available rooms are :\n";
    my @available_rooms = $dates_ok -> room_book();  
    print"@available_rooms\n";
 
    #room selection and validation
    ROOM:print"select room:\n";
    chomp(my $sel_room = <STDIN>);
    my $room_ok = new Roomverification();
    $room_ok -> room_validation($sel_room,@available_rooms);

    
    BOOK: 
    print"selected room : $sel_room\n";
    print"given check in date : $check_in_date\n";
    print "given check out date : $check_out_date\n";
    print"no:of persons : $nop\n";
    my ( $start, $end ) = (date($check_in_date), date($check_out_date));
    my $range = Date::Range->new( $start, $end );
    my @all_dates = $range->dates;
    $duration = scalar(@all_dates);
    print"total duration : $duration days\n";
    my $rate_per_day = '500';
    print"rent per day : $rate_per_day\n";
    $total_rate = $rate_per_day * $duration;
    print"Amound to be paid : $total_rate\n";
    
    CONFORM:print"type 'ok' to conform booking:\n";
    my $conformation = <STDIN>;
    if($conformation !~ 'ok')
    {
      print"not conformed\n";
      goto CID;
    }
    if($conformation =~ 'ok')
    {
     my $booking_details = new Database($usname,$emailid,$phone,$pass,$db,$check_in_date,$check_out_date,$nop,$sel_room,$duration,$total_rate);
     $booking_details -> new_book();
    }   
    
  }
  if($key == 2)
  {
   my $booking_details = new Database($usname,$emailid,$phone,$pass,$db,$check_in_date,$check_out_date,$nop,$sel_room,$duration,$total_rate);
     $booking_details -> my_bookings();
  }
  
  #logging out 
  if($key == 3)
  {
    print"logged out succesfully\n";
    goto START;
  }
  #modify booking
  if($key == 4)
  {
  print"modify booking\n";
    my $id;
    #username and password verification before modify bookings
    MD:print"enter the registered Username  : \n";
    my $uname = <STDIN>;
    print"enter the password : \n";
    my $pwd = <STDIN>;
    if($uname =~ $usname && $pwd =~ $pass)
    {
      my $booking_details = new Database($usname,$emailid,$phone,$pass,$db,$check_in_date,$check_out_date,$nop,$sel_room,$duration,$total_rate);
     $booking_details -> modify();
      my @booked_rooms = $booking_details -> modify();
      my$len = scalar(@booked_rooms);
     print"1)change check-in date : \n";
     print"2)change check-out date : \n";
     print"3)change no:of persons : \n";
     print"4)go to main menu : \n";
     OPT:print"select an option\n";
     my $option = <STDIN>;
    
     if($option =~ /^[1-4]$/)
     {    
       if($option == '4')
         {
          print"main menu\n";
          goto KEY;
         }
        print"enter the room number for which details has to be changed\n";
        BKR:my $newnum = <STDIN>;
        my $flag = 0;
        for(my$i=0;$i<$len;$i++)
        {
         if($newnum== $booked_rooms[$i])
         {
          $flag = $flag+1;
         }
        }
        if($flag >= 1)
        { 
         print"selected room : $newnum\n";
         print"This room has been booked $flag times\n";
          my $sth = $db->prepare("SELECT booking_id , room FROM guest WHERE room = $newnum and name = ('$usname')and phno = ('$phone') ");
         $sth->execute();
         my @book_id;
         my @mroom_db;
         while(my @booking_id = $sth->fetchrow_array())
         {
         push(@book_id,$booking_id[0]);
         push(@mroom_db,$booking_id[1])
         }
         print"booking id and its respective room number:\n";
         for(my$i=0;$i<scalar(@book_id);$i++)
         {
         print"booking id :$book_id[$i]  room no: $mroom_db[$i]\n";
         }
         print"select a booking id\n";
         ID:$id = <STDIN>;         
         my $len = scalar(@book_id);
         my $flag = 0;
         for(my$i=0;$i<$len;$i++)
         {
          if($id == $book_id[$i])
          {
           $flag = $flag+1;
          }
         }
         if($flag == 1)
         {
         goto MOD;
         } 
         else
         {
          print"enter a valid ID\n";
          goto ID;
         }  
        } 
        
        else
        {
         print"Invalid room number\n";
         goto BKR;
        }
         
       
       MOD:if($option == '1')
       { 
        NCID:print"enter the new check in date(yyyy-mm-dd) :\n";
        my $newcid = <STDIN>;
        my $newcid_ok = new Modify($newcid,$newnum,$id,$db);
        $newcid_ok -> new_cid();
        my $changed_cid = $newcid_ok -> new_cid();
        
        my $mod_cid = new Database();
        $mod_cid->cid($changed_cid,$newnum,$id,$db)        
       }
       
       if($option == '2')
       {
        NCOD:print"enter the new check out date :\n";
        my $newcod = <STDIN>;
        my $newcod_ok = new Modify($newcod,$newnum,$id,$db);
        $newcod_ok -> new_cod();
        my $changed_cod = $newcod_ok -> new_cod();
        
        my $mod_cod = new Database();
        $mod_cod->cod($changed_cod,$newnum,$id,$db)       
       }
       if($option == '3')
        {
          print"enter the new no:of persons :\n";
          my $newnop = <STDIN>;
          if($newnop =~ /^[1-3]$/)
         {
           my $mod_nop = new Database();
           $mod_nop->nop($newnop,$newnum,$id,$db)
         }  
         else
         {
          print"maximum 3 members only\n";
          goto MOD;
         }       
          
        }  
         
     }
     else
     {
       print"invalid option\n";
       goto OPT; 
     }    
    }
   else
    {
     print "invalid username or password\n";
     goto MD;
    }
   
  }
  #search option
  if($key == 5)
  {  OPT2:print"1.how many bookings done so far\n";
     print"2.total amount of money spend for bookings\n";
     print"3.previously choosed rooms\n";
     print"4.go to main menu\n";
     OPTN:print"select an option \n";
     my $select = <STDIN>;
     my $search = new Search($usname,$phone,$select,$db);
     $search -> option();
  }  
  if($key == 6)
  {
    CANCEL:print"cancel booking\n"; 
     #username and password verification before cancel booking
     print"enter the registered Username  : \n";
     my $uname = <STDIN>;
     print"enter the password : \n";
     my $pwd = <STDIN>;
     my $cancel = new Cancel($uname,$usname,$pwd,$pass,$phone,$db); 
     $cancel -> cancel_booking();
      
  }
  

}









