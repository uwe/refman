package RefMan::Command::InsertFees;

use Mojo::Base -strict, -signatures;

use Mojo::File;
use Mojo::JSON qw/decode_json/;

sub description {
  "Insert daily income from Dune result (JSON file) into vault_fees (DB table)."
}

sub run ($class, $refman, $file = 'data/dune-fees.json') {
  my $json = Mojo::File->new($file)->slurp;
  my $data = decode_json($json);

  my $dbh = $refman->dbh;
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
}

1;
