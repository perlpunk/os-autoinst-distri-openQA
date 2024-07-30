use Mojo::Base 'openQAcoretest';
use utils;
use testapi;

sub run {
    record_info 'HELLO';
    die "oops";
    wait_for_desktop;
}

1;

