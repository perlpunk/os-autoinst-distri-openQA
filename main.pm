#!/usr/bin/perl -w
use strict;
use testapi;
use autotest;
use needle;
use File::Find;

my $distri = testapi::get_var("CASEDIR") . '/lib/susedistribution.pm';
require $distri;
testapi::set_distribution(susedistribution->new());

$testapi::password //= get_var("PASSWORD");
$testapi::password //= 'nots3cr3t';

sub loadtest($) {
    my ($test) = @_;
    autotest::loadtest("/tests/$test");
}

sub load_install_tests() {
    loadtest "install/boot.pm";
    loadtest "show/clock.pm";
}

sub load_shutdown() {
    loadtest "shutdown/shutdown.pm";
}

# load tests in the right order
load_install_tests();
# testing from git only tests webui so far
load_shutdown();

1;
