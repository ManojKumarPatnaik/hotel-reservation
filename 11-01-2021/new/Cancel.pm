package Cancel;

sub new {
         my $class = shift;
         my $self = {
                     given_name =>shift,
                     username => shift,
                     given_pwd => shift,  
                     password => shift,       
                     phone => shift,   
                     database => shift             
                    };

        bless($self,$class);

        return $self;
        }

sub cancel_booking
{

    my ($self) = @_;
    my $uname = $self->{'given_name'};
    my $name = $self->{'username'}; 
    my $pwd = $self->{'given_pwd'};
    my $pass = $self->{'password'};
    my $phno = $self->{'phone'};
    my $dbh = $self->{'database'};
    print"gn$uname\n";
    print"un$name\n";
    print"gp$pwd\n";
    print"up$pass\n";
    print"ss$phno\n";
   if($uname =~ $name && $pwd =~ $pass)
   {
      my $sth = $dbh->prepare("SELECT room , check_in_date , check_out_date ,no_of_persons, no_of_days, amount, booking_id FROM guest WHERE name = ('$name')and phno = ('$phno')"); 
     $sth->execute();
  
     my $room_db = $sth->fetchrow_array();
     if($room_db =='')
      {
       print"no bookings till now\n";
       goto KEY;
      }   
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
      
       print"enter the registered phone number:\n";
       CPNO:my $reg_phno = <STDIN>;
       if($reg_phno !~ $phno)
       {
       print"number not registered\n";
       print"enter the registered phone number\n";
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
         goto BOOKROOM;
        } 
             
      CONFO:print"type 'ok' to conform booking:\n";
      my $conformation = <STDIN>;
      if($conformation !~ 'ok')
      {
       print"not conformed\n";
       goto CANCEL;
      }
      if($conformation =~ 'ok')
      {
       my $sth = $dbh->prepare("update rooms set check_in_date = NULL,check_out_date = NULL, no_of_persons = 0 where room= $booked_room"); 
       $sth->execute();
       my $sth = $dbh->prepare("DELETE FROM guest where booking_id = ('$id')"); 
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
1;      
      
