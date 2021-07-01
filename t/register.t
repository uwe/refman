use Mojo::Base -strict;

use Test::More;
use Test::Mojo;

use UUID::Random::Secure;

my $t = Test::Mojo->new('RefMan::Web');
$t->ua->max_redirects(1);

subtest 'Test Affiliate Registration' => sub {
  $t->get_ok('/')
    ->status_is(200)
    ->element_exists('form input[name="username"]')
    ->element_exists('form input[name="password"]')
    ->element_exists('form input[name="password2"]')
    ->element_exists('form input[name="address"]')
    ->element_exists('form input[type="submit"]');

  my $uuid = UUID::Random::Secure::generate;
  my $addr = '0x1234567890123456789012345678901234567890';
  my %data = (
    username => $uuid,
    password => $uuid,
    password2 => $uuid,
    address   => $addr,
  );
  $t->post_ok('/register' => form => \%data)
    ->status_is(200)
    ->content_like(qr/Your token: <mark>([0-9a-fA-F-]+)/);
};

done_testing();
