# RefMan - Referral Manager
Badger DAO Referral Program ([Gitcoin GR10 Bounty](https://gitcoin.co/issue/Badger-Finance/gitcoin/3/100025930))

## Web app

- allows affiliates (referrals, influencers) to register -> they get a token (UUID)
- users confirm this token by a signature
- all this is stored in a database (MySQL)
- start: `script/ref_man daemon`
- or better see `Dockerfile` (needs linked MySQL)

## Accounting part

- Deposits (and withdrawals) from confirmed users are added together for each affiliate
- at the end of the month each affiliate gets a share of the DAO profits (configurable per vault)
- Data sources:
  - Dune (daily profits in USD)
  - Subgraph (deposits and withdrawals)

## Verify signatures

- small node.js script to verify a signature (using `ethers`)
- used by `verify_signatures` command

## Commands

All commands are started by `perl cli.pl COMMAND`.

### calculate_affiliate_profits

Distributes a share of the DAO profits to affiliates (per vault per day). For each affiliate its user balances are summed up and the profits (percentage is configurable via `vaults` database table) are shared by ratio in regards to total supply. All calculations use numbers from the beginning of the day.

(This is the final step and has to run last.)

### insert_fees

Takes the output of TODO and stores it into the `vault_fees` database table.

### insert_shares

Queries the total supply for each vault (and day) and stores it into the `vault_shares` database table.

### verify_signatures

Verifies the user signatures and stores valid confirmations in `user_affiliates` database table.

## Database tables

### affiliate_profits

End result of the calculations, profit per vault per day for each affiliate.

### affiliates

Registered affiliates, stores Ethereum address and referral token.

### blocks

First Ethereum block of each day, used to transform days into blocks (and vice versa).

### signatures

User confirmations, still unvalidated. Stores the referral token (-> affiliate), block, address and signature.

### user_affiliate_balances

Balance per user per affiliate per vault per block.

### user_affiliates

Validated confirmations (from table `signatures`), produced by command `verify_signatures`. If an user confirms a new affiliate, then the older confirmation is terminated (`till_block` column).

### user_balances

Balance per user per vault per block.

### users

Ethereum addresses of users. (Used to produce smaller tables.)

### vault_fees

Daily USD income for each vault. Source: Dune (TODO).

### vault_shares

Daily total supply for each vault. Source: Subgraph (queried with first Ethereum block per day).

### vaults

Vault configuration (and mapping between Dune field name), stores address and profit share percentage.
