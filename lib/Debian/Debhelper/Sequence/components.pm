#!/usr/bin/perl
use warnings;
use strict;
use Debian::Debhelper::Dh_Lib;

insert_before("dh_installdirs", "dh_components");
#insert_before("dh_clean", "dh_components_purge");

1;
