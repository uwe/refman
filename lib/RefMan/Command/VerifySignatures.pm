package RefMan::Command::VerifySignatures;

use Mojo::Base -strict, -signatures;

sub description {
  "Verify signatures (DB table) and convert them to user_affiliates (DB table)."
}

sub run ($class, $refman) {
  my $dbh = $refman->dbh;
  my $all = $dbh->selectall_arrayref(
    'SELECT * FROM signatures WHERE status=? ORDER BY block, created_at',
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
      my $affiliate_id = $affiliate->{id};

      # is there a previous affiliate?
      my $sql = 'SELECT * FROM user_affiliates WHERE user_id=? and till_block IS NULL';
      my $old = $dbh->selectrow_hashref($sql, {}, $user_id);
      if ($old) {
        if ($old->{affiliate_id} == $affiliate_id) {
          # previous affiliate is the same - skip new DB entry (old one still valid)
          $dbh->do('UPDATE signatures SET status=? WHERE id=?', {}, 'confirmed', $row->{id});
          next;
        } else {
          # previous affiliate is different - end old entry
          $dbh->do(
            'UPDATE user_affiliates SET till_block=? WHERE user_id=?, affiliate_id=?, block=?',
            {},
            $block - 1, $old->{user_id}, $old->{affiliate_id}, $old->{block},
          );
        }
      }

      # write new entry (with open end)
      $dbh->do(
        "INSERT INTO user_affiliates (user_id, affiliate_id, from_block) VALUES (?, ?, ?)",
        {},
        $user_id, $affiliate_id, $block + 1,
      );

      $dbh->do('UPDATE signatures SET status=? WHERE id=?', {}, 'confirmed', $row->{id});
    }
  }
}

1;
