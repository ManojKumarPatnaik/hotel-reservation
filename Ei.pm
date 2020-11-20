package Ei;

use parent 'E';

use DBI;


sub new {
         my $class = shift;
         my $self = {
                     username => shift,
                     password => shift,
                   };

        bless($self,$class);

        return $self;
}

sub login
{
my ($self,$other) = @_;
my $name = $self->{'username'}; 
my $password = $self->{'password'};

my $dbh = DBI->connect("dbi:mysql:dbname=hotel;host=localhost",'ajith', 'Aspire@123') || die "Could not connect to database: $DBI::errstr";
print"connected to db\n";


my $sth = $dbh->prepare("SELECT password FROM users WHERE name = '$name'");
$sth->execute();
my $pass_db = $sth->fetchrow_array() ; 
print "$pass_db\n"; 
print"$password\n"; 
my $sth = $dbh->prepare("SELECT name FROM users WHERE password = '$password'");
$sth->execute();
my $name_db = $sth->fetchrow_array()  ;
 
print"$name_db\n";
print"$name\n"; 

if($name eq $name_db )
{
die"Invalid username\n";
}
if($password eq $pass_db)
{
die"Invalid password\n";
}
if ($name =~ $name_db  && $password =~ $pass_db) 
{
print"Welcome!\n";
print"Menu\n";
print"1.New book\n";
print"2.my booking\n";
print"3.logout\n";
print"4.modify booking\n";
print"5.search\n";
print"6.cancel booking\n";
print"Enter a key\n";
my $key = <STDIN>;
if($key ==1)
{

print"check in date(yyyy-mm-dd)\n";
my $cid = <STDIN>;
print"check out date(yyyy-mm-dd)\n";
my $cod = <STDIN>; 
print"enter number of persons:\n";
my $nop = <STDIN>;
print"enter number of rooms(max 3 persons per room):\n";
my $nor = <STDIN>;
my $sth = $dbh->prepare("SELECT check_in_date, check_out_date FROM rooms"); 
 
$sth->execute( ); 
  

  
while(($cid, $cod) = $sth->fetchrow_array())  
{ 
 print "room: $cid, nop: $cod\n";
  
use Date::Simple qw/date/;
use Date::Range;

my ( $start, $end ) = ( date($cid), date($cod) );
my $range = Date::Range->new( $start, $end );
my @all_dates = $range->dates;
print"@all_dates\n";
$duration = scalar(@all_dates);
print"total duration : $duration days\n";

}

my $rate_per_day = '500';
my $total_rate = $rate_per_day * $duration;
print"Amount to ba paid : $total_rate\n";

}
}
else
{
print"Invalid user name or password\n";
}


}
1;
