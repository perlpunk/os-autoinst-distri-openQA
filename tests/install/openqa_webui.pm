use strict;
use base "openQAcoretest";
use testapi;
use utils;

sub run {
    send_key "ctrl-alt-f3";
    assert_screen "inst-console";
    type_string "root\n";
    assert_screen "password-prompt";
    $testapi::password = 'nots3cr3t';
    type_string $testapi::password . "\n";
    wait_still_screen(2);
    diag('Ensure packagekit is not interfering with zypper calls');
    assert_script_run('systemctl mask --now packagekit');
    assert_script_run('zypper --no-cd -n in retry');

    my @packages = qw( docker git );
#    @packages = qw( chromium );
    assert_script_run("retry -s 30 -- zypper -n in @packages", timeout => 600);
    assert_script_run "systemctl start docker";
    assert_script_run "docker run --rm -p 31337:31337 -d yamlio/yaml-play-sandbox:0.1.30 31337";
    my $out = script_output "docker images";
    diag "Docker images: >>$out<<";

    sleep 1;
    switch_to_x11;
    sleep 1;
    ensure_unlocked_desktop();
    sleep 2;
    my $url = "https://play.yaml.io/main/parser";
    x11_start_program("firefox $url", 60, {valid => 1});
#    x11_start_program("chromium $url", 60, {valid => 1});
    sleep 4;
    assert_screen 'ff-playgound-start', 10;

    send_key 'ctrl-a';
    sleep 2;
    send_key 'delete';
    sleep 2;
    type_string "---\nopenQA: rocks!";

    assert_screen 'ff-playgound-enter-example', 10;
    mouse_set(232, 298);
    mouse_click 'left';
    sleep 2;
    assert_screen 'ff-playgound-click-sandbox', 10;
    mouse_set(672, 583);
    sleep 1;
    mouse_click 'left';

    send_key 'ctrl-t';
    type_string('https://0.0.0.0:31337/');
    send_key 'ret';
    assert_screen 'ff-playgound-local-cert-error', 10;

    mouse_set(797, 526);
    sleep 1;
    mouse_click 'left';
    assert_screen 'ff-playgound-local-cert-error-advanced', 10;
    send_key 'end';
    assert_screen 'ff-playgound-local-cert-error-advanced-scrolled-down', 10;

    mouse_set(684, 692);
    sleep 1;
    mouse_click 'left';
    assert_screen 'ff-playgound-local-cert-error-advanced-accept-risk', 10;

    mouse_set(712, 494);
    sleep 1;
    mouse_click 'left';
    assert_screen 'ff-playgound-local-cert-error-advanced-ok-close', 10;

    sleep 1;
    send_key 'ctrl-w';
    assert_screen 'ff-playgound-enter-example', 10;

    sleep 1;
    send_key 'f5';
    sleep 5;
    assert_screen 'ff-playgound-start-with-docker', 10;


    send_key 'ctrl-a';
    sleep 2;
    send_key 'delete';
    sleep 2;
    type_string "---\nopenQA: rocks!";
    assert_screen 'ff-playgound-enter-example-with-docker', 10;

    save_screenshot;
    clear_root_console;
}

1;
