package RefMan::Command;

use Mojo::Base -strict, -signatures;

use Mojo::Util qw/decamelize tablify/;
use Module::Find qw/useall/;

my @commands = useall 'RefMan::Command';

my %command = ();
foreach my $command (@commands) {
  my $name = (split(/-/, decamelize($command)))[-1];
  $command{$name} = $command;
}

sub run ($class, $refman, @args) {
  my $name = shift(@args) || '';
  my $command = $command{$name};
  if ($command) {
    $command->run($refman, @args);
  } else {
    my @out = ();
    foreach my $name (sort keys %command) {
      push @out, [$name, $command{$name}->description];
    }
    print tablify(\@out);
  }
}

1;
