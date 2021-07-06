package RefMan::Command::InsertBlocks;

use Mojo::Base -strict, -signatures;

use Mojo::File;
use Mojo::JSON qw/decode_json/;

sub description {
  "Insert first daily Ethereum block from Dune result (JSON file) into blocks (DB table)."
}

sub run ($class, $refman, $file = 'data/dune-blocks.json') {
  my $json = Mojo::File->new($file)->slurp;
  my $data = decode_json($json);

  my $dbh = $refman->dbh;
  my $sql = 'INSERT IGNORE INTO blocks (day, block) VALUES (?, ?)';

  foreach my $item (@{$data->{data}->{get_result_by_result_id}}) {
    my $day = $item->{data}->{day};
    $day =~ s/T00:00:00+00:00//;
    my $block = $item->{data}->{min};
    $dbh->do($sql, {}, $day, $block);
  }
}

1;
