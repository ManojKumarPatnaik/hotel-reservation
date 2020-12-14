package Register;

#package used
use DBI;

#constructor
sub new {
         my $class = shift;
         my $self = {
                     username => shift,
                     email=>shift,
                     phno=>shift,
                     password => shift,
                   };

        bless($self,$class);

        return $self;
        }

sub database
{
  my ($self,$other) = @_;
  my $dbh = DBI->connect("dbi:mysql:dbname=hotel;host=localhost",'ajith', 'Aspire@123') || die "Could not connect to database:  $DBI::errstr";
 
  my $name = $self->{'username'}; 
  my $email = $self->{'email'}; 
  my $phno = $self->{'phno'}; 
  my $password = $self->{'password'}; 
  my $sth = $dbh->prepare("SELECT phno FROM users WHERE phno = '$phno'");
  $sth->execute();
 
  my $phno_db = $sth->fetchrow_array() ; 
  
  #checking whether anyother users registered using same phone number
  if ($phno_db =~ $phno) 
   {
    print "The phone number already exists";
    goto PHNO;
   }
  else
  { 
    #entering the user details to database
    my $sth = $dbh->prepare("INSERT INTO users(name, email, phno, password)VALUES(?,?,?,?)"); 
    $sth->execute($name, $email, $phno, $password); 
   
    goto START;
  }
}


1;
