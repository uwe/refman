package RefMan::Web::Controller::Register;

use Mojo::Base 'Mojolicious::Controller', -signatures;
use Mojo::Util qw/trim/;

use Crypt::Argon2 qw/argon2id_pass/;
use Data::Dump qw/pp/;
use Math::Random::Secure qw/irand/;
use UUID::Random::Secure;


sub index ($self) {
  $self->stash(form => {}, error => {});
  $self->render(template => 'register');
}

# TODO only for testing - remove
sub test ($self) {
  my $uuid = UUID::Random::Secure::generate;
  my $addr = '0x1234567890123456789012345678901234567890';
  my %data = (
    username => $uuid,
    password => $uuid,
    password2 => $uuid,
    address   => $addr,
  );
  $self->stash(form => \%data, error => {});
  $self->render(template => 'register');
}

sub register ($self) {
  my %data = (
    username  => trim($self->param('username')  || ''),
    password  => trim($self->param('password')  || ''),
    password2 => trim($self->param('password2') || ''),
    address   => trim($self->param('address')   || ''),
  );

  # do some simple checks
  my %error = ();
  $error{username}  = 'Too short - at least 5 characters.' if length($data{username}) < 5;
  $error{password}  = 'Too short - at least 8 characters.' if length($data{password}) < 8;
  $error{password2} = 'Passwords not identical.' if $data{password} ne $data{password2};
  $error{address}   = 'Not a valid ETH address.' if $data{address} !~ /^0x[0-9a-fA-F]{40}$/;

  if (%error) {
    $self->stash(form => \%data, error => \%error);
    $self->render(template => 'register');
    return;
  }

  # hash password
  my $pw_hash = argon2id_pass($data{password}, irand(), 3, '32M', 1, 16);

  # generate token
  my $token = UUID::Random::Secure::generate;

  # store into DB
  my $dbh = $self->mysql->db->dbh;
  my $sql = 'INSERT INTO affiliates (username, password, token, address, created_at) VALUES (?, ?, ?, ?, NOW())';
  my $ok = $dbh->do($sql, {}, $data{username}, $pw_hash, $token, $data{address});

  unless ($ok) {
    if ($dbh->errstr =~ /Duplicate entry '.*' for key '(.+)'/) {
      $error{$1} = 'Already in use.'
    } else {
      $error{general} = 'Error saving to database. Please contact support.';
    }

    $self->stash(form => \%data, error => \%error);
    $self->render(template => 'register');
    return;
  }

  # redirect to token page
  $self->flash(token => $token);
  $self->redirect_to('token');
}

sub token ($self) {
  my $token = $self->flash('token');
  if ($token) {
    my $url = $self->app->config->{dapp_url} . '?ref=' . $token;
    $self->stash(token => $token, url => $url);
    $self->render(template => 'token');
  } else {
    $self->redirect_to('/');
  }
}

1;
