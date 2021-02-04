package Modify;

sub new {
         my $class = shift;
         my $self = {
                     date => shift, 
                     room => shift,
                     id => shift,   
                     database => shift             
                    };

        bless($self,$class);

        return $self;
        }
        
sub new_cid
 {
   my ($self) = @_;
   my $newcid = $self ->{'date'}; 
   my $newnum = $self ->{'room'};
   my $id = $self->{'id'};
   my $dbh = $self ->{'database'}; 
   
   
          my $sth = $dbh->prepare("SELECT check_out_date FROM guest WHERE room = $newnum and booking_id = ('$id')");
          $sth->execute();
          my $db_cod = $sth->fetchrow_array();
          my@date1 = split('-',$newcid);
          my @date2 = split('-',$db_cod);
        

          if($date1[0]==$date2[0] && $date1[1]==$date2[1] && $date1[2]<$date2[2])
          { 
            return $newcid;
          }
    
          elsif($date1[0]==$date2[0] && $date1[1] < $date2[1])
          {
            return $newcid;
          }
          elsif($date1[0] < $date2[0])
          {
            return $newcid;
          } 
          else
          {
            print"invalid check in date\n"; 
            goto NCID;
          }
         
         
       
 }
 

sub new_cod
 {
   my ($self) = @_;
   my $newcod = $self ->{'date'}; 
   my $newnum = $self ->{'room'};
   my $id = $self->{'id'};
   my $dbh = $self ->{'database'}; 
   
           my $sth = $dbh->prepare("SELECT check_in_date FROM guest WHERE room = $newnum and booking_id = ('$id')");
           $sth->execute();
           my $db_cid = $sth->fetchrow_array();
           my@date2 = split('-',$newcod);
           my @date1 = split('-',$db_cid);
           if($date1[0]==$date2[0] && $date1[1]==$date2[1] && $date1[2]<$date2[2])
           {  
            return $newcod;
           }
    
           elsif($date1[0]==$date2[0] && $date1[1] < $date2[1])
           {
            return $newcod;
           }
           elsif($date1[0] < $date2[0])
           {
            return $newcod;
           } 
           else
           {
            print"invalid check out date\n"; 
            goto NCOD;
           }
         
         
 }

                      
        
1;        
        
        
        
        
        
        
        
        
        
        
        
        
        
        
