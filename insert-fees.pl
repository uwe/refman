#!/usr/bin/env perl

use Mojo::Base -strict;

use Mojo::File;
use Mojo::JSON qw/decode_json/;

use rlib 'lib';
use RefMan;


my $refman = RefMan->new;
my $dbh = $refman->dbh;
$dbh->do('TRUNCATE vault_fees');


my $file = $ARGV[0] || 'dune-fees.json';
my $json = Mojo::File->new($file)->slurp;
my $data = decode_json($json);

my $sql = 'INSERT IGNORE INTO vault_fees (vault_id, day, usd) VALUES (?, ?, ?)';

foreach my $item (@{$data->{data}->{get_result_by_result_id}}) {
  my $day = $item->{data}->{day};
  $day =~ s/T00:00:00+00:00//;
  foreach my $key (keys %{$item->{data}}) {
    my $value = $item->{data}->{$key};
    next unless $value;

    my $vault = $refman->vaults->get_vault_by_dune($key);
    next unless $vault;

    $dbh->do($sql, {}, $vault->{id}, $day, $value);
  }
}