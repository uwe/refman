package RefMan::Vaults;

use Mojo::Base -strict, -signatures;

sub new ($class, $dbh) {
  # load vaults from database
  my $sql = 'SELECT * FROM vaults';
  my $all = $dbh->selectall_arrayref($sql, {Slice => {}});

  my $self = {
    address => {},
    dune    => {},
  };
  foreach my $vault (@$all) {
    $self->{address}->{lc($vault->{address})} = $vault;
    if ($vault->{dune}) {
      $self->{dune}->{$vault->{dune}} = $vault;
    }
  }

  return bless $self, $class;
}

sub get_vault_id ($self, $address) {
  my $vault = $self->{address}->{lc($address)};
  unless ($vault) {
    warn "Vault $address unknown.";
    return undef;
  }

  if ($vault->{ignore}) {
    return undef;
  }

  return $vault->{id};
}

sub get_all_dune_vaults ($self) {
  return values %{$self->{dune}};
}

sub get_vault_by_dune ($self, $column) {
  my $vault = $self->{dune}->{$column};
  return undef unless $vault;

  return $vault;
}

1;
