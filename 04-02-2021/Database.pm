package Database;
#database connection
use DBI;
use Date::Simple qw/date/;
use Date::Range;
sub new {
         my $class = shift;
         my $self = {
                     username => shift,
                     email =>shift,
                     phone => shift,
                     password => shift, 
                     database=>shift,
                     check_in_date =>shift,
                     check_out_date =>shift,
                     no_of_person => shift,
                     selected_room => shift,
                     no_of_days => shift,
                     total_rate => shift
                    };

        bless($self,$class);

        return $self;
        }
sub DB_connect
{
my $dbh = DBI->connect("dbi:mysql:dbname=hotel;host=localhost",'ajith', 'Aspire@123') || die "Could not connect to database: $DBI::errstr";
return $dbh;
}
sub register
{ 
   my ($self) = @_;
   my $name = $self->{'username'}; 
   my $email = $self->{'email'};  
   my $phno = $self->{'phone'}; 
   my $password = $self->{'password'};
   my $dbh = $self ->{'database'}; 
   my $sth = $dbh->prepare("INSERT INTO users(name, email, phno, password)VALUES(?,?,?,?)"); 
   $sth->execute($name, $email, $phno, $password); 
   print"registered sucessfully\n";
   goto START;
}
sub new_book
{
  my ($self) = @_;
   my $name = $self->{'username'}; 
   my $phno = $self->{'phone'}; 
   my $dbh = $self ->{'database'}; 
   my $cid = $self->{'check_in_date'}; 
   my $cod = $self->{'check_out_date'};  
   my $nop = $self->{'no_of_person'}; 
   my $sel_room = $self->{'selected_room'};
   my $duration = $self ->{'no_of_days'};
   my $total_rate = $self -> {'total_rate'};

 #updating the database after conformation
       my $sth = $dbh->prepare("update rooms set check_in_date = ('$cid'),check_out_date = ('$cod'),no_of_persons = ('$nop') where room= $sel_room"); 
       $sth->execute();
       print"booking details entered\n";
    
       #entering data to guest table
        my $sth = $dbh->prepare("insert into guest (name,phno,room,check_in_date ,check_out_date ,no_of_persons,no_of_days,amount) values (?,?,?,?,?,?,?,?)"); 
       $sth->execute($name,$phno,$sel_room,$cid,$cod,$nop,$duration,$total_rate); 
     
      #entering data to history table
       my $sth = $dbh->prepare("insert into history (name,phno,room,check_in_date ,check_out_date ,no_of_persons,no_of_days,amount) values (?,?,?,?,?,?,?,?)"); 
       $sth->execute($name,$phno,$sel_room,$cid,$cod,$nop,$duration,$total_rate); 
       print "booked succesfully\n";
       goto KEY;
}

sub my_bookings
{
   my ($self) = @_;
   my $name = $self->{'username'}; 
   my $phno = $self->{'phone'}; 
   my $dbh = $self ->{'database'}; 

   my $sth = $dbh->prepare("SELECT room , check_in_date , check_out_date ,no_of_persons, no_of_days, amount, booking_id FROM guest WHERE name = ('$name')and phno = ('$phno')");
     $sth->execute();
     
     while(my @booking_details = $sth->fetchrow_array())
     {
      print"room no:$booking_details[0]\n";
      print"check in date:$booking_details[1]\n";
      print"check out date:$booking_details[2]\n";
      print"no of persons : $booking_details[3]\n";
      print"no of days : $booking_details[4]\n";
      print"amount paid : $booking_details[5]\n";
      print"booking_id : $booking_details[6]\n";
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

sub modify
{
   my ($self) = @_;
   my $name = $self->{'username'}; 
   my $phno = $self->{'phone'}; 
   my $dbh = $self ->{'database'}; 
   my $sth = $dbh->prepare("SELECT room , check_in_date , check_out_date ,no_of_persons, no_of_days, amount, booking_id FROM history WHERE name = ('$name')and phno = ('$phno')"); 
   $sth->execute();
   my @booked_rooms;
   my $room_db = $sth->fetchrow_array();
   if($room_db =='')
   {
      print"no bookings till now\n";
      goto KEY;
   }  
   my $sth = $dbh->prepare("SELECT room , check_in_date , check_out_date ,no_of_persons, no_of_days, amount, booking_id FROM guest WHERE name = ('$name')and phno = ('$phno')"); 
   $sth->execute();
   while(my @booking_details = $sth->fetchrow_array())
   {
      print"room no:$booking_details[0]\n";
      push(@booked_rooms,$booking_details[0]); 
      print"check in date:$booking_details[1]\n";
      print"check out date:$booking_details[2]\n";
      print"no of persons: $booking_details[3]\n";
      print"no of days : $booking_details[4]\n";
      print"amount paid : $booking_details[5]\n";
      print"booking_id : $booking_details[6]\n";
      print"==================================\n";
    }
   return @booked_rooms;
}
sub cid
{  
     my($self,$newcid,$newnum,$id,$dbh) = @_;     
     my $sth = $dbh->prepare("update rooms set check_in_date = ('$newcid')where room= $newnum"); 
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
     print"check_in_date updated\n";
     goto KEY;

}

sub cod
{
     my($self,$newcod,$newnum,$id,$dbh) = @_; 
     my $sth = $dbh->prepare("update rooms set check_out_date = ('$newcod')where room= $newnum"); 
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
     print"check_out_date updated\n";
     goto KEY;
  
}
sub nop
{    my($self,$newnop,$newnum,$id,$dbh) = @_;
     my $sth = $dbh->prepare("update rooms set no_of_persons = ('$newnop') where room= $newnum"); 
     $sth->execute();
     my $sth = $dbh->prepare("update guest set no_of_persons = ('$newnop') where room= $newnum and booking_id = ('$id')"); 
     $sth->execute();
     my $sth = $dbh->prepare("update history set no_of_persons = ('$newnop') where room= $newnum and booking_id = ('$id')"); 
     $sth->execute();
     print"no : of persons updated\n";
     goto KEY;
}

















1;
