package RefMan::Command::CalculateAffiliateProfits;

use Mojo::Base -strict, -signatures;
use bigint;
use bignum;

use Data::Dump qw/pp/;
use Date::Simple qw/date today/;

sub description {
  "Calculate (daily) profit share for each affiliate into affiliate_profits (DB table)"
}

sub run ($class, $refman, $start_date = '2020-06-01') {
  my $dbh = $refman->dbh;
  $dbh->do('TRUNCATE TABLE affiliate_profits');

  # get vault profits
  my $sql = 'SELECT vault_fees.*, vault_shares.total_supply, blocks.block, vaults.percent FROM vault_fees, vault_shares, blocks, vaults
  WHERE vault_fees.vault_id = vault_shares.vault_id AND vault_fees.day = vault_shares.day AND
    vault_fees.day = blocks.day AND vault_fees.vault_id = vaults.id AND vault_fees.day >= ?';
  my $fees = $dbh->selectall_arrayref($sql, {Slice => {}}, $start_date);
  foreach my $row (@$fees) {
    my $vault_id     = $row->{vault_id};
    my $day          = $row->{day};
    my $profit       = $row->{usd};
    my $total_supply = $row->{total_supply};
    my $block        = $row->{block};
    my $percent      = $row->{percent};

    # get balances at this block
    $sql = 'SELECT user_id, affiliate_id, max(block) AS block FROM user_affiliate_balances WHERE vault_id=? AND block <= ? GROUP BY user_id, affiliate_id, vault_id';
    my $all = $dbh->selectall_arrayref($sql, {Slice => {}}, $vault_id, $block);
    my %affiliate = ();
    foreach my $row (@$all) {
      my $user_id      = $row->{user_id};
      my $affiliate_id = $row->{affiliate_id};
      my $block        = $row->{block};

      my ($balance) = $dbh->selectrow_array('SELECT balance FROM user_affiliate_balances WHERE user_id=? AND affiliate_id=? AND vault_id=? AND block=?', {}, $user_id, $affiliate_id, $vault_id, $block);
      $affiliate{$affiliate_id} += $balance;
    }

    next unless %affiliate;

    pp \%affiliate;

    while (my ($affiliate_id, $balance) = each %affiliate) {
      next if $balance == 0;

      printf(
        "Affiliate: %d - Vault: %d - Percentage: %.10f\n",
        $affiliate_id,
        $vault_id,
        100 * $balance / $total_supply,
      );

      my $profit_share = $profit * $percent / 100 * $balance / $total_supply;
      $dbh->do('INSERT INTO affiliate_profits (affiliate_id, vault_id, day, profit) VALUES (?, ?, ?, ?)', {}, $affiliate_id, $vault_id, $day, $profit_share);
    }
  }
}

1;
