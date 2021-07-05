#!/usr/bin/env perl

use Mojo::Base -strict;

use rlib 'lib';
use RefMan;

RefMan->new->command(@ARGV);
