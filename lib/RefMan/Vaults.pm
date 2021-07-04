package RefMan::Vaults;

use Mojo::Base -strict;

sub new {
  my ($class, $dbh) = @_;

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

sub get_vault_id {
  my ($self, $address) = @_;

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

sub get_all_dune_vaults {
  my ($self) = @_;

  return values %{$self->{dune}};
}

sub get_vault_by_dune {
  my ($self, $column) = @_;

  my $vault = $self->{dune}->{$column};
  return undef unless $vault;

  return $vault;
}

1;
