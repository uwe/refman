package RefMan::HandleTransactions;

use Mojo::Base -strict, -signatures;
use bigint;

sub deposits_to_transactions ($self, $deposits, $user_id) {
  my @transactions = ();
  foreach my $deposit (@$deposits) {
    my $address = $deposit->{vault}->{id};
    my $vault_id = $self->vaults->get_vault_id($address);
    next unless $vault_id;

    push @transactions, {
      user_id  => $user_id,
      shares   => $deposit->{shares},
      block    => $deposit->{transaction}->{blockNumber},
      vault_id => $vault_id,
    }
  }

  return @transactions;
}

sub withdrawals_to_transactions ($self, $withdrawals, $user_id) {
  my @transactions = ();
  foreach my $withdrawal (@$withdrawals) {
    my $address = $withdrawal->{vault}->{id};
    my $vault_id = $self->vaults->get_vault_id($address);
    next unless $vault_id;

    push @transactions, {
      user_id  => $user_id,
      shares   => 0 - $withdrawal->{shares},
      block    => $withdrawal->{transaction}->{blockNumber},
      vault_id => $vault_id,
    }
  }

  return @transactions;
}

sub add_transaction ($self, $tx) {
  # get previous balance
  my $sql = "SELECT balance FROM user_balances WHERE vault_id=? AND user_id=? ORDER BY block DESC LIMIT 1";
  my $row = $self->dbh->selectrow_hashref($sql, {}, $tx->{vault_id}, $tx->{user_id});

  my $balance = $tx->{shares};
  if ($row) {
    $balance += $row->{balance};
  }

  $self->dbh->do(
    "INSERT INTO user_balances (vault_id, user_id, block, balance) VALUES (?, ?, ?, ?)",
    {},
    $tx->{vault_id},
    $tx->{user_id},
    $tx->{block},
    $balance,
  );

  # is there an affiliate attached?
  my $affiliate_id = $self->get_affiliate_for_user($tx->{user_id}, $tx->{block});
  return unless $affiliate_id;

  if ($tx->{shares} < 0) {
    $self->add_affiliate_withdraw($tx, $row->{balance});
  } else {
    $self->add_affiliate_deposit($tx, $affiliate_id);
  }
}

sub add_affiliate_deposit ($self, $tx, $affiliate_id) {
  # get previous balance
  my $sql = "SELECT balance FROM user_affiliate_balances WHERE vault_id=? AND user_id=? AND affiliate_id=? ORDER BY block DESC LIMIT 1";
  my $row = $self->dbh->selectrow_hashref($sql, {}, $tx->{vault_id}, $tx->{user_id}, $affiliate_id);

  my $balance = $tx->{shares};
  if ($row) {
    $balance += $row->{balance};
  }

  $self->dbh->do(
    "INSERT INTO user_affiliate_balances (vault_id, user_id, affiliate_id, block, balance) VALUES (?, ?, ?, ?, ?)",
    {},
    $tx->{vault_id},
    $tx->{user_id},
    $affiliate_id,
    $tx->{block},
    $balance,
  );
}

sub add_affiliate_withdraw ($self, $tx, $old_total_balance) {
  # get all affiliate balances
  my $sql = "SELECT affiliate_id FROM user_affiliate_balances WHERE vault_id=? AND user_id=? GROUP BY user_id, affiliate_id, vault_id";
  my $affiliates = $self->dbh->selectcol_arrayref($sql, {Slice => {}}, $tx->{vault_id}, $tx->{user_id});

  # apply ratio to all of them
  foreach my $affiliate_id (@$affiliates) {
    # get previous balance
    my $sql = "SELECT balance FROM user_affiliate_balances WHERE vault_id=? AND user_id=? AND affiliate_id=? ORDER BY block DESC LIMIT 1";
    my $row = $self->dbh->selectrow_hashref($sql, {}, $tx->{vault_id}, $tx->{user_id}, $affiliate_id);

    if ($row) {
      $self->dbh->do(
        "INSERT INTO user_affiliate_balances (vault_id, user_id, affiliate_id, block, balance) VALUES (?, ?, ?, ?, ?)",
        {},
        $tx->{vault_id},
        $tx->{user_id},
        $affiliate_id,
        $tx->{block},
        # $tx->{shares} is negative
        $row->{balance} + $row->{balance} * $tx->{shares} / $old_total_balance,
      );
    } else {
      warn "Affiliate found, but no balance."
    }
  }
}

1;
