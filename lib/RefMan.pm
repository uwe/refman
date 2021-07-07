package RefMan;

use Mojo::Base -base, -signatures;

use Data::Dump qw/pp/;
use Mojo::mysql;
use Mojo::UserAgent;

use RefMan::Vaults;

use base 'RefMan::HandleTransactions';
use RefMan::Command;

has config => sub {
  do "./refman.conf";
};

has ua => sub {
  Mojo::UserAgent->new;
};

has mysql => sub ($self) {
  Mojo::mysql->strict_mode($self->config->{mysql});
};

has vaults => sub ($self) {
  RefMan::Vaults->new($self->dbh);
};

sub dbh ($self) {
  $self->mysql->db->dbh;
}

sub get_user_id ($self, $address) {
  # is the address already known?
  my ($id) = @{$self->dbh->selectcol_arrayref("SELECT id FROM users WHERE LOWER(address)=?", {}, lc($address))};
  return $id if $id;

  # create new user
  $self->dbh->do("INSERT INTO users (address) VALUES (?)", {}, $address);
  return $self->dbh->last_insert_id;
}

sub get_affiliate_for_user ($self, $user_id, $block) {
  my $sql = "SELECT affiliate_id FROM user_affiliates WHERE user_id=? AND from_block<=? AND (till_block<? OR till_block IS NULL)";
  my ($id) = @{$self->dbh->selectcol_arrayref($sql, {}, $user_id, $block, $block)};
  return $id;
}

sub command ($self, @args) {
  RefMan::Command->run($self, @args);
}

sub subgraph ($self, $query, $variables) {
  my $body = {
    query => $query,
    variables => $variables,
  };
  my $res = $self->ua->post(
    $self->config->{subgraph_url},
    json => $body,
  )->res;
  unless ($res->is_success) {
    pp $variables;
    say $res->to_string;
    return;
  }

  return $res->json->{data};
}

1;
