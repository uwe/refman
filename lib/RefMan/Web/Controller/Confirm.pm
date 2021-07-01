package RefMan::Web::Controller::Confirm;

use Mojo::Base 'Mojolicious::Controller', -signatures;

sub index ($self) {
  my $token = $self->param('ref');
  my $error = '';
  if ($token) {
    # check token validity
    my $dbh = $self->mysql->db->dbh;
    my $sql = 'SELECT token FROM affiliates WHERE token=?';
    my $row = $dbh->selectrow_hashref($sql, {}, $token);
    unless ($row) {
      $error = 'TOKEN_INVALID';
    }
  } else {
    $error = 'TOKEN_MISSING';
  }

  if ($error) {
    $self->stash(error => $error);
    $self->render(template => 'confirm-error');
  } else {
    $self->stash(token => $token);
    $self->render(template => 'confirm');
  }
}

1;
