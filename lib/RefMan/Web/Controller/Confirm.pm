package RefMan::Web::Controller::Confirm;

use Mojo::Base 'Mojolicious::Controller', -signatures;
use Mojo::Util qw/trim/;

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

sub confirm ($self) {
  my %data = (
    token     => trim($self->param('token')     || ''),
    block     => trim($self->param('block')     || ''),
    address   => trim($self->param('address')   || ''),
    signature => trim($self->param('signature') || ''),
  );

  # store everything (without error checks) - we validate the signature later (via cron job)

  my $dbh = $self->mysql->db->dbh;
  my $sql = 'INSERT INTO signatures (token, block, address, signature) VALUES (?, ?, ?, ?)';
  my $ok = $dbh->do($sql, {}, $data{token}, $data{block}, $data{address}, $data{signature});

  if ($ok) {
    $self->stash(deposit_url => $self->app->config->{deposit_url});
    $self->render(template => 'thankyou');
  } else {
    $self->render(template => 'thankyou-error');
  }
}

1;
