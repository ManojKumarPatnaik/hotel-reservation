package Login;

#packages used
 
use parent 'Register';
use Date::Simple qw/date/;
use Date::Range;
use DBI;

#constructor

sub new {
         my $class = shift;
         my $self = {
                     username => shift,
                     password => shift,
                     phone => shift
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
  my $key;
  
  #database connection
  my $dbh = DBI->connect("dbi:mysql:dbname=hotel;host=localhost",'ajith', 'Aspire@123') || die "Could not connect to database: $DBI::errstr";
  print"connected to db\n";

  #password verification
  my $sth = $dbh->prepare("SELECT password FROM users WHERE name = '$name'");
  $sth->execute();
  my $pass_db = $sth->fetchrow_array() ; 
  print "$pass_db\n"; 
  print"$password\n"; 
  if($pass_db eq '')
  {
   print "invalid username\n re-enter the username:\n";
   goto NAME;
  } 
  
  #username verification
  my $sth = $dbh->prepare("SELECT name FROM users WHERE password = '$password'");
  $sth->execute();
  my $name_db = $sth->fetchrow_array()  ;
  if($name_db eq '')
  {
   print "invalid password\n re-enter the password\n";
   goto PASS;
  }  
  print"$name_db\n";
  print"$name\n"; 
  
  #phone number verification
  my $sth = $dbh->prepare("SELECT phno FROM users WHERE phno = '$phno'");
  $sth->execute();
  my $phno_db = $sth->fetchrow_array()  ;
  if($phno_db eq '')
  {
   print "invalid phone number\n re-enter the phone no:\n";
   goto PNO;
  }  
   print "1)$phno_db\n";
   print"2)$phno\n";
   
  #page displayed after login
  if ($name =~ $name_db  && $password =~ $pass_db && $phno =~ $phno_db) 
  {
   print"Welcome!\n";
   print"Menu\n";
   print"1.New book\n";
   print"2.my booking\n";
   print"3.logout\n";
   print"4.modify booking\n";
   print"5.search\n";
   print"6.cancel booking\n";
   
   #selction options
   KEY:print"Enter a key\n";
   $key = <STDIN>;
   if($key !~ /[1-6]/)
   {
   print"Enter a valid key\n";
   goto KEY;
   }
   
   #new bookings
   if($key ==1)
   {  
     #getting check in date
     CID:print"check in date(yyyy-mm-dd) :\n";
     chomp(my $cid = <STDIN>);
     if($cid =~ /^\d{4}\-(0[1-9]|1[012])\-(0[1-9]|[12][0-9]|3[01])$/)

     {
     print"$cid\n";
     print"check out date(yyyy-mm-dd) :\n";
     }
     else
     {
     print"invalid date . please enter the date in given format\n";
     goto CID;
     }
     
     #getting check out date
     COD:chomp(my $cod = <STDIN>); 
     if($cid =~ /^\d{4}\-(0[1-9]|1[012])\-(0[1-9]|[12][0-9]|3[01])$/)
     {
     print"$cod\n";
     print"enter number of persons(Max 3 persons per room) :\n";
     }
     else
     {
     print"invalid date . please enter the date in given format\n";
     goto COD;
     }
     
     #getting number of persons
     NOP:chomp(my $nop = <STDIN>);
     if($nop =~ /[1-3]/)
     {
     print "Thank you\n";
     }
     else
     {
     print"maximum 3 members per room\n";
     goto NOP;
     }
     
     #displaying available rooms for given requirements
     my $sth = $dbh->prepare("SELECT all room FROM rooms WHERE check_in_date != ('$cid') and ('$cid') not between check_in_date and check_out_date or check_in_date is NULL");
     $sth->execute();
     while(my@room_db = $sth->fetchrow_array())
      {  
       print"available rooms are :@room_db\n";
      }
 
     #room selection and validation
     print"select room:\n";
     ROOM:my $sel_room = <STDIN>;
     if($sel_room =~ /[1][0-1][0-9]/)
     { 
      #displaying given information
      print"given check in date : $cid\n";
      print "given check out date : $cod\n";
      print"no:of persons : $nop\n"; 
      
      #booking conformation
      print"type 'ok' to conform booking:\n";
      my $conformation = <STDIN>;
      if($coformation ne 'ok')
      {
      goto CID;
      }
      if($conformation eq 'ok')
      {
      my ( $start, $end ) = (date($cid), date($cod));
      my $range = Date::Range->new( $start, $end );
      my @all_dates = $range->dates;
      my $duration = scalar(@all_dates);
      print"total duration : $duration days\n";
      my $rate_per_day = '500';
      my $total_rate = $rate_per_day * $duration;
      print"Amound to be paid : $total_rate\n";
     
      #updating the database after conformation
      my $sth = $dbh->prepare("update rooms set check_in_date = ('$cid'),check_out_date = ('$cod'),no_of_persons = ('$nop') where room= $sel_room"); 
      $sth->execute();
      print"booking details entered\n";
    
      #entering data to guest table
      my $sth = $dbh->prepare("insert into guest (room,check_in_date,check_out_date,name,phno,no_of_days,amount) values (?,?,?,?,?,?,?)"); 
      $sth->execute($sel_room,$cid,$cod,$name,$phno,$duration,$total_rate); 
     
      #entering data to history table
      my $sth = $dbh->prepare("insert into history (name,phno,room,check_in_date ,check_out_date ,no_of_persons,no_of_days,amount) values (?,?,?,?,?,?,?,?)"); 
      $sth->execute($name,$phno,$sel_room,$cid,$cod,$nop,$duration,$total_rate); 
      print "booked succesfully\n";
     
    }
    #if room number entered wrongly
    else
    {
    print"enter a valid room number\n";
    goto ROOM;
    }
    }
  
    }
  }
  #if username and password missmatched
  else
  {
    print"Invalid user name or password\n";
  }
   
   #my booking options
   if($key == 2)
   {
     my $sth = $dbh->prepare("SELECT room , check_in_date , check_out_date , no_of_days, amount FROM guest WHERE name = ('$name')and phno = ('$phno')");
     $sth->execute();
     
     while(my @booking_details = $sth->fetchrow_array())
     {
     print"room no:$booking_details[0]";
     print"check in date:$booking_details[1]\n";
     print"check out date:$booking_details[2]\n";
     print"no of days : $booking_details[3]\n";
     print"amount paid : $booking_details[4]\n";
     }
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
    
    #username and password verification before modify bookings
    print"enter the registered Username  : \n";
    my $uname = <STDIN>;
    print"enter the password : \n";
    my $pwd = <STDIN>;
    if($usname == $name && $pwd == $password)
    {
    goto CID;
    }
    else
    {
     print "invalid username or password\n";
     goto KEY;
    }
    }
    
    #cancel booking
    if($key == 6)
    {
     CANCEL:print"cancel booking\n";
     
     #username and password verification before cancel booking
     print"enter the registered Username  : \n";
     my $uname = <STDIN>;
     print"enter the password : \n";
     my $pwd = <STDIN>;
     if($usname == $name && $pwd == $password)
     {
      #manual conformation
      my $conformation = <STDIN>;
      if($coformation ne 'ok')
      {
      goto CANCEL;
      }
      if($conformation eq 'ok')
      {
      print"enter the registered phone number:\n";
      my $reg_phno = <STDIN>;
      print "enter the booked room no : \n";
      my $booked_room = <STDIN>;
      print"enter the given check_in_date :\n";
      my $booked_cid = <STDIN>;
      print"enter the given check_out_date\n";
      my $booked_cod = <STDIN>;
      my $sth = $dbh->prepare("update rooms set check_in_date = ('NULL'),check_out_date = ('NULL'),no_of_persons = ('NULL') where room= $booked_room"); 
      $sth->execute();
      my $sth = $dbh->prepare("DELETE FROM guest where name = ('$name') and password = ('$password')"); 
      $sth->execute();
      my $sth = $dbh->prepare("DELETE FROM history where name = ('$name') and password = ('$password')"); 
      $sth->execute();
      }
     }
    } 

 
}
1;



























