package RefMan::Command::CalculateBalances;

use Mojo::Base -strict, -signatures;
use bigint;

sub description {
  "Calculate user (and affiliate) balances from Subgraph queries."
}

sub run ($self, $refman) {
  my $dbh = $refman->dbh;
  foreach my $table (qw/user_affiliate_balances user_balances/) {
    $refman->dbh->do("TRUNCATE TABLE $table");
  }

  my $query = <<'END';
query getTransactions($id: ID!) {
  account(id: $id) {
    id
    deposits {
      vault { id }
      shares
      transaction { blockNumber }
    }
    withdrawals {
      vault { id }
      shares
      transaction { blockNumber }
    }
  }
}
END

  # get all users that have affiliates confirmed
  my $sql = 'SELECT DISTINCT(users.id), users.address FROM users, user_affiliates WHERE users.id = user_affiliates.user_id';
  my $all = $dbh->selectall_arrayref($sql, {Slice => {}});
  foreach my $row (@$all) {
    my $user_id = $row->{id};
    my $address = $row->{address};

    my $data = $refman->subgraph($query, {id => $address});
    next unless $data;

    my $account = $data->{account};
    printf(
      "%s - %d deposits and %d withdrawals\n",
      $address,
      scalar(@{$account->{deposits}}),
      scalar(@{$account->{withdrawals}}),
    );

    # mix deposits and withdrawals
    my @transaction = (
      $refman->deposits_to_transactions($account->{deposits}, $user_id),
      $refman->withdrawals_to_transactions($account->{withdrawals}, $user_id),
    );

    # sort by block number
    @transaction = sort { $a->{block} <=> $b->{block} } @transaction;

    # now calculate balance per vault
    foreach my $tx (@transaction) {
      $refman->add_transaction($tx);
    }
  }
}

1;
