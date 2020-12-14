package Login;

#packages used
 
use parent 'Register';
use Date::Simple qw/date/;
use Date::Range;
use DBI;
use DateTime; 
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
 

  #password verification
  my $sth = $dbh->prepare("SELECT password FROM users WHERE name = '$name'");
  $sth->execute();
  my $pass_db = $sth->fetchrow_array() ; 
  print "$pass_db\n"; 
  print"$password\n"; 
  if($pass_db eq '')
  {
   print "invalid username\n";
   goto NAME;
  } 
  
  #username verification
  my $sth = $dbh->prepare("SELECT name FROM users WHERE password = '$password'");
  $sth->execute();
  my $name_db = $sth->fetchrow_array()  ;
  if($name_db eq '')
  {
   print "invalid password\n";
   goto PASS;
  }  
  
 
  
  #phone number verification
  my $sth = $dbh->prepare("SELECT phno FROM users WHERE phno = '$phno'");
  $sth->execute();
  my $phno_db = $sth->fetchrow_array()  ;
  if($phno_db eq '')
  {
   print "invalid phone number\n";
   goto PNO;
  }  
  
   
  #page displayed after login
  if ($name =~ $name_db  && $password =~ $pass_db && $phno =~ $phno_db) 
  {
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
   $key = <STDIN>;
   if($key !~ /^[1-6]$/)
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
     
     my @date1 = split('-',$cid);
     if($date1[1] == '09' or $date1[1] == '04' or $date1[1] == '06' or $date1[1] == '11')
     {
       if($date1[2] <= '30')
       {
        goto CH;
       }
       else
       {
        print"incorrect date\n";
        goto CID;
       }
     }
     
     elsif($date1[1] == '02' && $date1[0]%4 == '0') 
     {
       if($date1[2] <= '29')
       {
        goto CH;
       }
       else
       {
       print"incorrect date\n";
       goto CID;
       }
      }
     elsif($date1[1] == '02' && $date1[0]%4 != '0') 
      {
        if($date1[2] <= '28')
        {
         goto CH;
        }
        else
        {
        print"incorrect date\n";
        goto CID;
        }
      }
       
     CH:if($cid =~ /^\d{4}\-(0[1-9]|1[012])\-(0[1-9]|[12][0-9]|3[01])$/)
     {
      my $datetime = DateTime->now;   
      @datetime = split('-',$datetime);
      my @cid = split('-',$cid);
      if($datetime[0] > $cid[0] ) 
      {
      print"invalid check in da\n";
      goto CID;
      }
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
     my @date2 = split('-',$cod);
     if($date2[1] == '09' or $date2[1] == '04' or $date2[1] == '06' or $date2[1] == '11')
     {
       if($date2[2] <= '30')
       {
        goto CH1;
       }
       else
       {
        print"incorrect date\n";
        print"enter a correct check out date(yyyy-mm-dd) :\n";
        goto COD;
       }
     }
     
     elsif($date2[1] == '02' && $date2[0]%4 == '0') 
     {
       if($date2[2] <= '29')
       {
        goto CH1;
       }
       else
       {
       print"incorrect date\n";
       print"enter a correct check out date(yyyy-mm-dd) :\n";
       goto COD;
       }
      }
     elsif($date2[1] == '02' && $date2[0]%4 != '0') 
      {
        if($date2[2] <= '28')
        {
         goto CH1;
        }
        else
        {
        print"incorrect date\n";
        print"enter a correct check out date(yyyy-mm-dd) :\n";
        goto COD;
        }
      }
     CH1:if($cod =~ /^\d{4}\-(0[1-9]|1[012])\-(0[1-9]|[12][0-9]|3[01])$/)
     {
      my $datetime = DateTime->now;   
      @datetime = split('-',$datetime);
      my @cod = split('-',$cod);
      if($datetime[0] > $cod[0] ) 
      {
      print"invalid check in date\n";
      print"enter a correct check out date(yyyy-mm-dd) :\n";
      goto COD;
      }
      print"$cod\n";
     }
     else
     {
      print"invalid date . please enter the date in given format\n";
      goto COD;
     }
     my@date1 = split('-',$cid);
     my @date2 = split('-',$cod);

    if($date1[0]==$date2[0] && $date1[1]==$date2[1] && $date1[2]<$date2[2])
     { 
      goto NOP;
     }
    
    elsif($date1[0]==$date2[0] && $date1[1] < $date2[1])
    {
     goto NOP;
    }
    elsif($date1[0] < $date2[0])
    {
     goto NOP;
    }
    else
    {
     print"invalid check in date or check out date\n"; 
     goto CID;
    }
     #getting number of persons
     NOP:print"enter number of persons(Max 3 persons per room) :\n";
     chomp(my $nop = <STDIN>);
     if($nop =~ /^[1-3]$/)
     {
      print "Thank you\n";
     }
     else
     {
      print"maximum 3 members per room\n";
      goto NOP;
     }
     #displaying available rooms for given requirements
     my $sth = $dbh->prepare("SELECT all room FROM rooms WHERE check_in_date != ('$cid') and ('$cid') not between check_in_date and check_out_date and ('$cod') not between check_in_date and check_out_date and check_in_date not between ('$cid') and ('$cod')or check_in_date is NULL");
     $sth->execute();
      print"available rooms are :\n";
     my@available_rooms;
     while(my@rooms = $sth->fetchrow_array())
      {  
       
       print"@rooms\n";
       push(@available_rooms,@rooms);
      }
     
     my $len = scalar(@available_rooms);
     
     #room selection and validation
     ROOM:print"select room:\n";
     my $sel_room = <STDIN>;
     my $flag = 0;
     for(my$i=0;$i<$len;$i++)
     {
      if($sel_room == $available_rooms[$i])
      {
       $flag = $flag+1;
      }
     }
     if($flag==1)
     {
       print"selected room : $sel_room\n";
       goto BOOK;
     }
     else
     {
      print"Invalid room number\n";
      goto ROOM;
     }
    
      
      #displaying given information
      BOOK:print"given check in date : $cid\n";
      print "given check out date : $cod\n";
      print"no:of persons : $nop\n";
       
       my ( $start, $end ) = (date($cid), date($cod));
       my $range = Date::Range->new( $start, $end );
       my @all_dates = $range->dates;
       my $duration = scalar(@all_dates);
       print"total duration : $duration days\n";
       my $rate_per_day = '500';
       print"rent per day : $rate_per_day\n";
       my $total_rate = $rate_per_day * $duration;
       print"Amound to be paid : $total_rate\n";
       #booking conformation
       CONFORM:print"type 'ok' to conform booking:\n";
       my $conformation = <STDIN>;
       if($conformation !~ 'ok')
       {
        print"not conformed\n";
        goto CID;
       }
       if($conformation =~ 'ok')
       {
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
       goto KEY;
      }  
      
  
    }
  }
  #if username and password missmatched
  else
  {
    print"Invalid  password\n";
    goto PASS;
  }
   
   #my booking details
   if($key == 2)
   {
     my $sth = $dbh->prepare("SELECT room , check_in_date , check_out_date , no_of_days, amount, booking_id FROM guest WHERE name = ('$name')and phno = ('$phno')");
     $sth->execute();
     
     while(my @booking_details = $sth->fetchrow_array())
     {
     print"room no:$booking_details[0]";
     print"check in date:$booking_details[1]\n";
     print"check out date:$booking_details[2]\n";
     print"no of days : $booking_details[3]\n";
     print"amount paid : $booking_details[4]\n";
      print"booking_id : $booking_details[5]\n";
     print"==================================\n";
    }
     my $sth = $dbh->prepare("SELECT room FROM guest WHERE name = ('$name')and phno = ('$phno')");
     $sth->execute();
     my $room_db = $sth->fetchrow_array();
     if($room_db =='')
     {
      print"no bookings till now\n";
      goto KEY;
     }  
     
     goto KEY;
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
    print"enter the registered Username  : \n";
    my $uname = <STDIN>;
    print"enter the password : \n";
    my $pwd = <STDIN>;
    if($uname =~ $name && $pwd =~ $password)
    {
     my $sth = $dbh->prepare("SELECT room , check_in_date , check_out_date ,no_of_persons, no_of_days, amount, booking_id FROM history WHERE name = ('$name')and phno = ('$phno')"); 
     $sth->execute();
     my @booked_rooms;
     my $room_db = $sth->fetchrow_array();
     if($room_db =='')
     {
      print"no bookings till now\n";
      goto KEY;
     }  
     my $sth = $dbh->prepare("SELECT room , check_in_date , check_out_date ,no_of_persons, no_of_days, amount, booking_id FROM history WHERE name = ('$name')and phno = ('$phno')"); 
     $sth->execute();
     while(my @booking_details = $sth->fetchrow_array())
     {
      print"room no:$booking_details[0]";
      push(@booked_rooms,$booking_details[0]); 
      print"check in date:$booking_details[1]\n";
      print"check out date:$booking_details[2]\n";
      print"no of persons: $booking_details[3]\n";
      print"no of days : $booking_details[4]\n";
      print"amount paid : $booking_details[5]\n";
      print"booking_id : $booking_details[6]\n";
      print"==================================\n";
     }

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
          my $sth = $dbh->prepare("SELECT booking_id , room FROM guest WHERE room = $newnum");
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
      NCID:print"enter the new check in date(yyy-mm-dd) :\n";
      my $newcid = <STDIN>;
      my @date1 = split('-',$newcid);
     if($date1[1] == '09' or $date1[1] == '04' or $date1[1] == '06' or $date1[1] == '11')
     {
       if($date1[2] <= '30')
       {
        goto CH3;
       }
       else
       {
        print"incorrect date\n";
        goto NCID;
       }
     }
     
     elsif($date1[1] == '02' && $date1[0]%4 == '0') 
     {
       if($date1[2] <= '29')
       {
        goto CH3;
       }
       else
       {
       print"incorrect date\n";
       goto NCID;
       }
      }
     elsif($date1[1] == '02' && $date1[0]%4 != '0') 
      {
        if($date1[2] <= '28')
        {
         goto CH3;
        }
        else
        {
        print"incorrect date\n";
        goto NCID;
        }
      }
        CH3:if($newcid =~ /^\d{4}\-(0[1-9]|1[012])\-(0[1-9]|[12][0-9]|3[01])$/)
        {
         my $datetime = DateTime->now;   
         @datetime = split('-',$datetime);
         my @cid = split('-',$newcid);
         if($datetime[0] > $cid[0] ) 
         {
          print"invalid check in date\n";
          goto NCID;
         }
       
         
         my $sth = $dbh->prepare("SELECT check_out_date FROM guest WHERE room = $newnum and booking_id = ('$id')");
         $sth->execute();
         my $db_cod = $sth->fetchrow_array();
         print"$newcid\n";
         print"$db_cod\n";
         print"$id\n";
         my@date1 = split('-',$newcid);
         my @date2 = split('-',$db_cod);
        

         if($date1[0]==$date2[0] && $date1[1]==$date2[1] && $date1[2]<$date2[2])
         { 
          goto CON;
         }
    
         elsif($date1[0]==$date2[0] && $date1[1] < $date2[1])
         {
          goto CON;
         }
         elsif($date1[0] < $date2[0])
         {
          goto CON;
         } 
         else
         {
           print"invalid check in date\n"; 
           goto NCID;
         }
         CON:my $sth = $dbh->prepare("update rooms set check_in_date = ('$newcid')where room= $newnum"); 
         $sth->execute();  
         my $sth = $dbh->prepare("update guest set check_in_date = ('$newcid')where room= $newnum and booking_id = ('$id')"); 
         $sth->execute();
         my $sth = $dbh->prepare("update history set check_in_date = ('$newcid')where room= $newnum and booking_id = ('$id')"); 
         $sth->execute();
         print"check in date is updated\n";
         my $sth = $dbh->prepare("SELECT check_in_date , check_out_date  FROM guest WHERE room = $newnum and check_in_date = ('$newcid')");
          $sth->execute();
          my @det = $sth->fetchrow_array()  ;
          my ( $start, $end ) = (date($det[0]), date($det[1]));
          my $range = Date::Range->new( $start, $end );
          my @all_dates = $range->dates;
          my $duration = scalar(@all_dates);
          print"total duration : $duration days\n";
          my $rate_per_day = '500';
          my $total_rate = $rate_per_day * $duration;
          print"Amound to be paid : $total_rate\n";
          my $sth = $dbh->prepare("update guest set no_of_days = ('$duration') , amount = ('$total_rate') where room= $newnum and booking_id = ('$id')"); 
          $sth->execute();
          my $sth = $dbh->prepare("update history set no_of_days = ('$duration') , amount = ('$total_rate') where room= $newnum and booking_id = ('$id')"); 
          $sth->execute();
          
          goto KEY;
        
        }
        else
        {
        print"invalid check in date\n";
        goto MOD
        }
       }
        if($option == '2')
        {
         
         NCOD:print"enter the new check out date :\n";
         my $newcod = <STDIN>;
         my @date2 = split('-',$newcod);
     if($date2[1] == '09' or $date2[1] == '04' or $date2[1] == '06' or $date2[1] == '11')
     {
       if($date2[2] <= '30')
       {
        goto CH2;
       }
       else
       {
        print"incorrect date\n";
        print"enter a correct check out date(yyyy-mm-dd) :\n";
        goto NCOD;
       }
     }
     
     elsif($date2[1] == '02' && $date2[0]%4 == '0') 
     {
       if($date2[2] <= '29')
       {
        goto CH2;
       }
       else
       {
       print"incorrect date\n";
       print"enter a correct check out date(yyyy-mm-dd) :\n";
       goto NCOD;
       }
      }
     elsif($date2[1] == '02' && $date2[0]%4 != '0') 
      {
        if($date2[2] <= '28')
        {
         goto CH2;
        }
        else
        {
        print"incorrect date\n";
        print"enter a correct check out date(yyyy-mm-dd) :\n";
        goto NCOD;
        }
      }  
        CH2:if($newcod =~ /^\d{4}\-(0[1-9]|1[012])\-(0[1-9]|[12][0-9]|3[01])$/)
         {
         
         my $sth = $dbh->prepare("SELECT check_in_date FROM guest WHERE room = $newnum and booking_id = ('$id')");
         $sth->execute();
         my $db_cid = $sth->fetchrow_array();
         my@date2 = split('-',$newcod);
         my @date1 = split('-',$db_cid);

         if($date1[0]==$date2[0] && $date1[1]==$date2[1] && $date1[2]<$date2[2])
         { 
          goto CON1;
         }
    
         elsif($date1[0]==$date2[0] && $date1[1] < $date2[1])
         {
          goto CON1;
         }
         elsif($date1[0] < $date2[0])
         {
          goto CON1;
         } 
         else
         {
           print"invalid check out date\n"; 
           goto NCOD;
         }
    
           CON1:my $sth = $dbh->prepare("update rooms set check_out_date = ('$newcod')where room= $newnum"); 
          $sth->execute();
          my $sth = $dbh->prepare("update guest set check_out_date = ('$newcod')where room= $newnum and booking_id = ('$id')"); 
          $sth->execute();
          my $sth = $dbh->prepare("update history set check_out_date = ('$newcod')where room= $newnum and booking_id = ('$id')"); 
          $sth->execute();
          print"check out date is updated\n";
          my $sth = $dbh->prepare("SELECT check_in_date , check_out_date  FROM guest WHERE room = $newnum and check_out_date = ('$newcod')");
          $sth->execute();
          my @det = $sth->fetchrow_array()  ;
          my ( $start, $end ) = (date($det[0]), date($det[1]));
          my $range = Date::Range->new( $start, $end );
          my @all_dates = $range->dates;
          my $duration = scalar(@all_dates);
          print"total duration : $duration days\n";
          my $rate_per_day = '500';
          my $total_rate = $rate_per_day * $duration;
          print"Amound to be paid : $total_rate\n";
          my $sth = $dbh->prepare("update guest set no_of_days = ('$duration') , amount = ('$total_rate') where room= $newnum and booking_id = ('$id')"); 
          $sth->execute();
          my $sth = $dbh->prepare("update history set no_of_days = ('$duration') , amount = ('$total_rate') where room= $newnum and booking_id = ('$id')"); 
          $sth->execute();
          goto KEY;
   
        }
        else
        {
        print"Invalid check out date";
        goto MOD;
        }
       }
        if($option == '3')
        {
          print"enter the new no:of persons :\n";
          my $newnop = <STDIN>;
         if($newnop =~ /^[1-3]$/)
         {
           my $sth = $dbh->prepare("update rooms set no_of_persons = ('$newnop') where room= $newnum"); 
         $sth->execute();
           my $sth = $dbh->prepare("update history set no_of_persons = ('$newnop') where room= $newnum and booking_id = ('$id')"); 
       $sth->execute();
           print"no : of persons updated\n";
           goto KEY;
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
     goto KEY;
    }
    }
    
    #search
    if($key == 5)
    {
     print"1.how many bookings done so far\n";
     print"2.total amount of money spend for bookings\n";
     print"3.previously choosed rooms\n";
     print"4.go to main menu\n";
     OPTN:print"select an option \n";
     my $select = <STDIN>;
     if($select =~ /^[1-4]$/)
     {
     if($select == 1)
     {
       my $sth = $dbh->prepare("SELECT room FROM guest WHERE name = ('$name')and phno = ('$phno')");
       $sth->execute();
       my $count = 0;
       while(my @search = $sth->fetchrow_array())
       {
         $count++;
       }
        print"no:of bookings done so far : $count \n";
     }
      if($select == 2)
      {
      my $sth = $dbh->prepare("SELECT amount FROM guest WHERE name = ('$name')and phno = ('$phno')");
       $sth->execute();
       my$sum = 0;
       while(my @search = $sth->fetchrow_array())
       {
         $sum = $sum+$search[0];
       }
       print"total amount : $sum\n";
      } 
 
     if($select == 3)
     {
      my $sth = $dbh->prepare("SELECT room FROM guest WHERE name = ('$name')and phno = ('$phno')");
       $sth->execute();
       print"previously booked are :\n"; 
       while(my @search = $sth->fetchrow_array())
       {
         print"room no:$search[0]";
       }
      }
     if($select == '4')
      {
      print"main menu\n"; 
      goto KEY;
      }
      }
      else
      {
      print"invalid option\n";
      goto OPTN;
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
     if($uname =~ $name && $pwd =~ $password)
     {
      print"your bookings\n";
      my $sth = $dbh->prepare("SELECT room , check_in_date , check_out_date , no_of_days, amount, booking_id FROM guest WHERE name = ('$name')and phno = ('$phno')");
      $sth->execute();
      my @booked_rooms;
      while(my @booking_details = $sth->fetchrow_array())
      {
       print"booking id :$booking_details[5]\n";
       print"room no :$booking_details[0]\n";
       print"================================\n";
       push(@booked_rooms,$booking_details[0]);
      }
      
      
       CPNO:print"enter the registered phone number:\n";
       my $reg_phno = <STDIN>;
       if($reg_phno !~ $phno)
       {
       goto CPNO;
       }
       my$len = scalar(@booked_rooms);
       BOOKROOM:print "enter the room no for cancellation : \n";
       my $booked_room = <STDIN>;
       my $flag = 0;
        for(my$i=0;$i<$len;$i++)
        {
         if($booked_room == $booked_rooms[$i])
         {
          $flag = $flag+1;
         }
        }
        if($flag>=1)
        {
          print"selected room : $booked_room\n";
          my $sth = $dbh->prepare("SELECT booking_id FROM guest WHERE room = $booked_room  and phno = $phno");
          $sth->execute();
          my @book_id;
          while(my @booking_id = $sth->fetchrow_array())
          {
            push(@book_id,$booking_id[0]);
          }
          print"booking id's are : @book_id\n";
          print"select a booking id\n";
          ID1:$id = <STDIN>;
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
           goto CONFO;
          } 
          else
          {
          print"enter a valid ID\n";
          goto ID1;
          } 
         }  
        else
        {
         print"Invalid room number\n";
         goto BKROOM;
        } 
       
             
      CONFO:print"type 'ok' to conform booking:\n";
      my $conformation = <STDIN>;
      if($conformation !~ 'ok')
      {
       print"not conformed\n";
       goto CONFO;
      }
      if($conformation =~ 'ok')
      {
       my $sth = $dbh->prepare("update rooms set check_in_date = NULL,check_out_date = NULL,no_of_persons = NULL where room= $booked_room"); 
       $sth->execute();
       my $sth = $dbh->prepare("DELETE FROM guest where room = ('$booked_room') and phno = ('$reg_phno') and booking_id = ('$id')"); 
       $sth->execute();
       my $sth = $dbh->prepare("DELETE FROM history where room = ('$booked_room') and phno = ('$reg_phno') and booking_id = ('$id')"); 
       $sth->execute();
       print"booking canceled\n";
       goto KEY;
      }
     
     }
     else
     {
     print"invalid username or password\n";
     goto CANCEL;
     }
  }
  else
  {
   print"invalid username or password\n";
   goto START;
 } 
 

 
}
1;


