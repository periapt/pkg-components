#!perl -T

use Test::More;
use Test::Pod::Coverage tests=>1;
pod_coverage_ok('Debian::Debhelper::Dh_components');
