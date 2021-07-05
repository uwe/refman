package RefMan::Command::InsertShares;

use Mojo::Base -strict, -signatures;

use Mojo::UserAgent;

my $url = "https://api.thegraph.com/subgraphs/name/uwe/badger-setts";

sub description {
  "Insert daily total supply (from subgraph) into vault_shares (DB table)."
}

sub run ($class, $refman, $start_date = '2021-07-01') {
  my $ua = Mojo::UserAgent->new;

  # get start block for each day
  my $dbh = $refman->dbh;
  my $sql = 'SELECT * FROM blocks WHERE day >= ? ORDER BY day';
  my $all = $dbh->selectall_arrayref($sql, {Slice => {}}, $start_date);

  my $query = <<END;
query totalSupply(\$block: Int) {
  vaults(block: {number: \$block}) {
    id
    totalSupplyRaw
  }
}
END

  foreach my $row (@$all) {
    my $day = $row->{day};
    my $block = $row->{block};

    # get total supply from subgraph
    my $body = {
      query => $query,
      variables => {block => $block},
    };
    my $data = $ua->post($url, json => $body)->res->json;

    my %supply = map { lc($_->{id}) => $_->{totalSupplyRaw} } @{$data->{data}->{vaults}};

    # we are only interested in a few vaults
    foreach my $vault ($refman->vaults->get_all_dune_vaults) {
      $dbh->do(
        'INSERT IGNORE INTO vault_shares (vault_id, day, total_supply) VALUES (?, ?, ?)',
        {},
        $vault->{id},
        $day,
        $supply{lc($vault->{address})},
      )
    }
  }
}

1;
