CREATE TABLE `affiliates` (
  `id` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `username` varchar(255) CHARACTER SET utf8 COLLATE utf8_bin NOT NULL DEFAULT '',
  `password` varchar(255) CHARACTER SET utf8 COLLATE utf8_bin NOT NULL DEFAULT '',
  `token` varchar(255) NOT NULL,
  `address` varchar(255) CHARACTER SET utf8 COLLATE utf8_bin NOT NULL DEFAULT '',
  `created_at` datetime NOT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `token` (`token`),
  UNIQUE KEY `username` (`username`),
  KEY `address` (`address`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

CREATE TABLE `blocks` (
  `day` date NOT NULL,
  `block` int(10) unsigned NOT NULL,
  PRIMARY KEY (`day`),
  KEY `block` (`block`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

CREATE TABLE `confirmations` (
  `id` int(11) unsigned NOT NULL AUTO_INCREMENT,
  `affiliate` int(10) unsigned NOT NULL,
  `address` varchar(255) NOT NULL DEFAULT '',
  `signature` text NOT NULL,
  `signed_at` datetime NOT NULL,
  `from_block` int(10) unsigned DEFAULT NULL,
  `till_block` int(10) unsigned DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

CREATE TABLE `signatures` (
  `id` int(11) unsigned NOT NULL AUTO_INCREMENT,
  `token` varchar(255) DEFAULT NULL,
  `block` int(10) unsigned DEFAULT NULL,
  `address` varchar(255) DEFAULT NULL,
  `signature` varchar(255) DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

CREATE TABLE `user_affiliate_balances` (
  `user_id` int(10) unsigned NOT NULL,
  `affiliate_id` int(10) unsigned NOT NULL,
  `vault_id` int(10) unsigned NOT NULL,
  `block` int(10) unsigned NOT NULL,
  `balance` decimal(65,0) NOT NULL,
  PRIMARY KEY (`user_id`,`affiliate_id`,`vault_id`,`block`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

CREATE TABLE `user_affiliates` (
  `user_id` int(10) unsigned NOT NULL,
  `affiliate_id` int(10) unsigned NOT NULL,
  `from_block` int(10) unsigned NOT NULL,
  `till_block` int(10) unsigned DEFAULT NULL,
  PRIMARY KEY (`user_id`,`affiliate_id`,`from_block`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

CREATE TABLE `user_balances` (
  `user_id` int(10) unsigned NOT NULL,
  `vault_id` int(10) unsigned NOT NULL,
  `block` int(10) unsigned NOT NULL,
  `balance` decimal(65,0) NOT NULL,
  PRIMARY KEY (`user_id`,`vault_id`,`block`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

CREATE TABLE `users` (
  `id` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `address` varchar(255) NOT NULL DEFAULT '',
  PRIMARY KEY (`id`),
  UNIQUE KEY `address` (`address`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

CREATE TABLE `vaults` (
  `id` int(11) unsigned NOT NULL AUTO_INCREMENT,
  `name` varchar(255) DEFAULT NULL,
  `token` varchar(255) DEFAULT NULL,
  `address` varchar(255) NOT NULL DEFAULT '',
  `percent` decimal(5,3) NOT NULL,
  `dune` varchar(255) DEFAULT NULL,
  `api` varchar(255) DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
