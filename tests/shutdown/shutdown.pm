use strict;
use base "basetest";
use testapi;

sub run {

    send_key "ctrl-alt-f3";
    assert_screen "inst-console";
    type_string "root\n";
    assert_screen "password-prompt";
    $testapi::password = 'nots3cr3t';
    type_string $testapi::password . "\n";
    wait_still_screen(2);

    enter_cmd 'cd';
    assert_screen "root-console";
    enter_cmd "poweroff";
    assert_shutdown 300;
}

sub post_fail_hook {
    # in case plymouth splash screen on shutdown hides some messages
    send_key 'esc' if check_screen 'plymouth';
}

1;
