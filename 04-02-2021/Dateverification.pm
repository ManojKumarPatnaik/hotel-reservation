package Dateverification;
use DateTime;
sub new {
         my $class = shift;
         my $self = {
                     date => shift,
                     other => shift                     
                    };

        bless($self,$class);

        return $self;
}

sub check_date
{
 my ($self) = @_;
 my $cd = $self->{'date'}; 
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
        return 1;
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
        return 1;
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
         return 1;
        }
      }
       
  CH:if($cd =~ /^\d{4}\-(0[1-9]|1[012])\-(0[1-9]|[12][0-9]|3[01])$/)
     {
      my $datetime = DateTime->now;   
      @datetime = split('-',$datetime);
      my @cd = split('-',$cd);
      if($datetime[0] > $cd[0] ) 
      {
       print"invalid  date\n";
       return 1;
      }


     }
     else
     {
      print"invalid date . please enter the date in given format\n";
      return 1;
     }
}


sub compare
{   my ($self) = @_;
    my $cid = $self->{'date'};
    my $cod = $self->{'other'}; 
    
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
     print"invalid check in date or check out date \n"; 
     goto CID;
    }
}


1;


















