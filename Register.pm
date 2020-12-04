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
  print"connected to db\n";
  my $name = $self->{'username'}; 
  my $email = $self->{'email'}; 
  my $phno = $self->{'phno'}; 
  my $password = $self->{'password'}; 
  my $sth = $dbh->prepare("SELECT phno FROM users WHERE phno = '$phno'");
  $sth->execute();
 
  my $phno_db = $sth->fetchrow_array() ; 
  
  #checking whether anyother users registered using same phone number
  if ($phno ne '') 
   {
    die "The phone number already exists";
   }
  else
  { 
    #entering the user details to database
    my $sth = $dbh->prepare("INSERT INTO users(name, email, phno, password)VALUES(?,?,?,?)"); 
    $sth->execute($name, $email, $phno, $password); 
    print("data entered\n");
  }
}


1;
