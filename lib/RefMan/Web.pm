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

  # remove on production
  $r->get('/uwe')->to('register#test');

  # Affiliate Registration
  $r->get('/register')->to('register#index')->name('register');
  $r->post('/register')->to('register#register');
  $r->get('/token')->to('register#token')->name('token');

  # User Confirmation
  $r->get('/confirm')->to('confirm#index')->name('confirm');
  $r->post('/confirm')->to('confirm#confirm');
  $r->get('/thankyou')->to('confirm#thankyou')->name('thankyou');
}

1;
