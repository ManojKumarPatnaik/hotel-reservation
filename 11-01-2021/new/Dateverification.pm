package Dateverification;
use DateTime;
sub new {
         my $class = shift;
         my $self = {
                     date => shift                     
                    };

        bless($self,$class);

        return $self;
}

sub check_in_date
{
 my ($self) = @_;
 my $cid = $self->{'date'}; 
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
      return $cod;

     }
     else
     {
      print"invalid date . please enter the date in given format\n";
      goto CID;
     }
}

sub check_out_date
{    my ($self) = @_;
     my $cod = $self->{'date'}; 
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
      print"invalid check out date\n";
      print"enter a correct check out date(yyyy-mm-dd) :\n";
      goto COD;
      }
      
      return $cod;
      
     }
     else
     {
      print"invalid date . please enter the date in given format\n";
      goto COD;
     }
    
}

sub compare
{   
       
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
}


1;


















