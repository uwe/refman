package RefMan;

use Mojo::Base -base;
use Mojo::mysql;

has config => sub {
  do "./refman.conf";
};

has mysql => sub {
  Mojo::mysql->strict_mode((shift)->config->{mysql});
};

sub dbh {
  (shift)->mysql->db->dbh;
}

1;
