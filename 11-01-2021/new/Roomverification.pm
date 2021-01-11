package Roomverification;

sub new {
         my $class = shift;
         my $self = {
                     check_in_date => shift,
                     check_out_date => shift, 
                     database=>shift                 
                    };

        bless($self,$class);

        return $self;
        }
        
sub room_book
{
my ($self) = @_;

my $cid = $self->{'check_in_date'};
my $cod = $self->{'check_out_date'};
my $dbh = $self->{'database'};

my $sth = $dbh->prepare("SELECT all room FROM rooms WHERE check_in_date != ('$cid') and ('$cid') not between check_in_date and check_out_date and ('$cod') not between check_in_date and check_out_date and check_in_date not between ('$cid') and ('$cod')or check_in_date is NULL");
     $sth->execute();
     my@db_rooms;
     while(my@rooms = $sth->fetchrow_array())
      {  
       push(@db_rooms,@rooms);
      }
     my $len1 = scalar(@db_rooms);
     
     my $sth = $dbh->prepare("SELECT all room FROM guest WHERE ('$cid') between check_in_date and check_out_date or ('$cod')  between check_in_date and check_out_date or check_in_date  between ('$cid') and ('$cod') or check_in_date = ('$cid') and check_out_date = ('$cod')");
     $sth->execute();
     
     my@guest_rooms;
     while(my@rooms = $sth->fetchrow_array())
      {  
       push(@guest_rooms,@rooms);
      }
     my $len2 = scalar(@guest_rooms);
     
     my @available_rooms;  
     my $count = 0;
     for(my$itr = 0 ;$itr<$len1 ; $itr++)
     {$count = 0; 
      for(my$jtr = 0 ;$jtr<$len2 ; $jtr++)
      {
       if($db_rooms[$itr] != $guest_rooms[$jtr])
       {
        $count ++;
       }
      }
      if($count == $len2)
      {
       push(@available_rooms,$db_rooms[$itr]);
      }
     }    
      
      return @available_rooms;
}

sub room_validation
{
#room validation
     my ($self,$room,@rooms) = @_;
     my $sel_room = $room;
     my @available_rooms = @rooms;
     my $flag = 0;
     my $len = scalar(@available_rooms);
     for(my$i=0;$i<$len;$i++)
     {
      if($sel_room eq $available_rooms[$i])
      {
       $flag = $flag+1;
      }
     }
     if($flag==1)
     {
      return $sel_room; 
      goto BOOK;
     }
     else
     {
      print"Invalid room number\n";
      goto ROOM;
     }

}




1;




























