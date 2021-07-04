#!/usr/bin/env perl

use strict;
use warnings;
use feature qw/say/;
use bigint;

use rlib 'lib';
use RefMan;
use RefMan::Demo::Account13;
use RefMan::Demo::Account78;

use Data::Dump qw/pp/;


my $refman = RefMan->new;
foreach my $table (qw/users user_affiliate_balances user_balances/) {
  $refman->dbh->do("TRUNCATE TABLE $table");
}

my $demo = {
  RefMan::Demo::Account13->account => RefMan::Demo::Account13->data,
  RefMan::Demo::Account78->account => RefMan::Demo::Account78->data,
};

while (my ($account, $data) = each %$demo) {
  my $user_id = $refman->get_user_id($account);

  # mix deposits and withdrawals
  my @transaction = (
    $refman->deposits_to_transactions($data->{deposits}, $user_id),
    $refman->withdrawals_to_transactions($data->{withdrawals}, $user_id),
  );

  # sort by block number
  @transaction = sort { $a->{block} <=> $b->{block} } @transaction;

  # now calculate balance per vault
  foreach my $tx (@transaction) {
    $refman->add_transaction($tx);
  }
}
