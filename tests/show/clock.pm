use strict;
use base "basetest";
use testapi;
use utils;
use Time::HiRes qw/ usleep /;

sub run {
#    send_key "ctrl-alt-f3";
#    assert_screen "inst-console";
#    type_string "root\n";
#    assert_screen "password-prompt";
#    $testapi::password = 'nots3cr3t';
#    type_string $testapi::password . "\n";
#    wait_still_screen(2);
#    diag('Ensure packagekit is not interfering with zypper calls');
#    assert_script_run('systemctl mask --now packagekit');
#    assert_script_run('zypper --no-cd -n in retry');

#    my @packages = qw( git-core perl perl-Date-Calc perl-Tk perl-App-cpanminus make gnome-clocks );
#    @packages = qw( gnome-clocks );
#    assert_script_run("retry -s 30 -- zypper -n in @packages", timeout => 600);

#    sleep 1;
#    switch_to_x11;
#    sleep 1;
    ensure_unlocked_desktop;
    sleep 2;
    x11_start_program("gnome-clocks", 60, {valid => 1});
#     assert_and_click($mustmatch [, timeout => $timeout] [, button => $button] [, clicktime => $clicktime ] [, dclick => 1 ] [, mousehide => 1 ]);

    assert_screen 'clock-started', 10;
    sleep 1;
    assert_and_click 'clock-started', timeout => 10, clicktime => 1;

    assert_screen 'new-timer-menu', 10;
    sleep 1;
    assert_and_click 'new-timer-menu', timeout => 10, dlick => 1;
    sleep 1;
    send_key 'delete';
    sleep 1;
    type_string '10';
    sleep 1;
    send_key 'tab';

    assert_screen 'new-timer-menu-selected-10s', 10;
    sleep 1;
    assert_and_click 'new-timer-menu-selected-10s', timeout => 10;

    sleep 2;
    assert_screen 'timer-running', 10;
    sleep 2;

    assert_screen 'timer-finished', 10;

    sleep 10;

    return;

    assert_screen 'ff-playgound-enter-example-with-docker', 10;

    save_screenshot;
    clear_root_console;
}

sub test_flags {
    return {fatal => 1};
}

1;
