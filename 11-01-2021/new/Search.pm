package Search;
sub new {
         my $class = shift;
         my $self = {
                     username => shift,
                     phone => shift,
                     option => shift,   
                     database => shift             
                    };

        bless($self,$class);

        return $self;
        }

sub option
{   
   my ($self) = @_;
   my $name = $self->{'username'}; 
   my $phno = $self->{'phone'};
   my $select = $self ->{'option'}; 
   my $dbh = $self ->{'database'}; 
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
        goto OPT2;
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
       goto OPT2;
      } 
 
     if($select == 3)
      {
         my $sth = $dbh->prepare("SELECT booking_id , room FROM guest WHERE name = ('$name')and phno = ('$phno') ");
         $sth->execute();
         my @book_id;
         my @mroom_db;
         while(my @booking_id = $sth->fetchrow_array())
         {
           push(@book_id,$booking_id[0]);
           push(@mroom_db,$booking_id[1]);
         }
         print"booking id and its respective room number:\n";
         for(my$i=0;$i<scalar(@book_id);$i++)
         {
          print"booking id :$book_id[$i]  room no: $mroom_db[$i]\n";
         }
         goto OPT2;
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
      goto OPT2;
     }
    
}        
1;        
        
