package RefMan::Web;

use Mojo::Base 'Mojolicious', -signatures;
use Mojo::mysql;

sub startup ($self) {
  my $config = $self->plugin('Config', {file => 'refman.conf'});
  $self->secrets($config->{secrets});

  $self->helper(mysql => sub { state $mysql = Mojo::mysql->new(shift->config('mysql')) });

  my $r = $self->routes;

  $r->get('/' => sub ($c) {
    $c->redirect_to('register');
  });
  $r->get('/register')->to('register#index')->name('register');
  $r->get('/uwe')->to('register#test');
  $r->post('/register')->to('register#register');
  $r->get('/token')->to('register#token')->name('token');
}

1;
