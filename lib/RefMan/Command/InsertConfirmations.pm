package RefMan::Command::InsertConfirmations;

use Mojo::Base -strict, -signatures;

sub description {
  "Check signatures (DB table) and convert them to confirmations (DB table)."
}

sub run ($class, $refman) {
  my $dbh = $refman->dbh;
  my $all = $dbh->selectall_arrayref(
    'SELECT * FROM signatures WHERE status=? ORDER BY block',
    {Slice => {}},
    'open',
  );
  foreach my $row (@$all) {
    my @error = ();

    # check input values
    my $token = $row->{token};
    if ($token !~ /^[[:xdigit:]]{8}-[[:xdigit:]]{4}-[[:xdigit:]]{4}-[[:xdigit:]]{4}-[[:xdigit:]]{12}$/) {
      push @error, "Invalid token: $token";
    }

    my $block = $row->{block};
    if ($block !~ /^\d{8,}$/) {
      push @error, "Invalid block: $block";
    }

    my $signature = $row->{signature};
    if ($signature !~ /^0x[[:xdigit:]]{130}$/) {
      push @error, "Invalid signature: $signature";
    }

    # verify signature (via node.js app using ethers)
    my $address = `cd verify-signature && node . $row->{token} $row->{block} $row->{signature}`;
    chomp $address;
    if ($address !~ /^0x[[:xdigit:]]{40}$/) {
      push @error, "Invalid address: $address";
    }

    if (lc($address) ne lc($row->{address})) {
      push @error, "Wrong address vs. signature";
    }

    # find affiliate
    my $affiliate = $dbh->selectrow_hashref('SELECT * FROM affiliates WHERE token=?', {}, $token);
    unless ($affiliate) {
      push @error, "No affiliate found for token: $token";
    }

    warn "verify block - time window of 1 hour?";

    if (@error) {
      my $errors = join("\n", @error);
      warn $errors;
      $dbh->do('UPDATE signatures SET status=?, error=? WHERE id=?', {}, 'invalid', $errors, $row->{id});
      next;
    } else {
      my $user_id = $refman->get_user_id($address);
      $dbh->do(
        "INSERT INTO confirmations (user_id, affiliate_id, from_block) VALUES (?, ?, ?)",
        {},
        $user_id, $affiliate->{id}, $block + 1,
      );
      $dbh->do('UPDATE signatures SET status=? WHERE id=?', {}, 'confirmed', $row->{id});
    }
  }
}

1;
