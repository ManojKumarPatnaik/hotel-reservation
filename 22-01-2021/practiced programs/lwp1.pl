my $url = 'http://freshair.npr.org/dayFA.cfm?todayDate=current';
    # Just an example: the URL for the most recent /Fresh Air/ show

  use LWP::Simple;
  my $content = get $url;
  die "Couldn't get $url" unless defined $content;

  # Then go do things with $content, like this:

  if($content =~ m/williams/i) {
    print "Match found!\n";
  } else {
    print "Match not found.\n";
  }
