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
        else
        {
          print"invalid check in date\n";
          goto MOD
        }
         
       
 }
 

sub new_cod
 {
   my ($self) = @_;
   my $newcod = $self ->{'date'}; 
   my $newnum = $self ->{'room'};
   my $id = $self->{'id'};
   my $dbh = $self ->{'database'}; 
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
         else
         {
          print"invalid check out date\n";
          goto MOD
         }
         
 }

                      
        
1;        
        
        
        
        
        
        
        
        
        
        
        
        
        
        
