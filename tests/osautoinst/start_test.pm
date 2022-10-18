use strict;
use base "openQAcoretest";
use testapi;
use utils;

sub run {
    # please forgive the hackiness: using the openQA API but parsing the
    # human-readable output of 'client' to get the most recent job
    my $arch       = get_var('ARCH');
    my $ttest      = 'minimalx';
    my $openqa_url = get_var('OPENQA_HOST', 'https://openqa.opensuse.org');
    my $cmd        = <<"EOF";
set -o pipefail
last_tw_build=\$(OPENQA_CLI_RETRIES=5 openqa-cli api --host $openqa_url assets | jq '.assets | .[] | .name' | sed -n 's/.*Tumbleweed-NET-$arch-Snapshot\\([0-9]\\+\\)-Media.*\$/\\1/p' | sort -n | tail -n 1)
echo "Last Tumbleweed build on openqa.opensuse.org: \$last_tw_build"
[ ! -z \$last_tw_build ]
zypper -n in jq
resp=\$(OPENQA_CLI_RETRIES=5 openqa-cli api --host $openqa_url jobs version=Tumbleweed scope=relevant arch=$arch build=\$last_tw_build flavor=NET latest=1)
job_id=\$(echo "\$resp" | jq '.jobs | .[] | select(.test == "$ttest") | .id')
echo "Job Id: \$job_id"
if [ -z \$job_id  ]; then echo "Response: \$resp" && false; fi
echo "Scenario: $arch-$ttest-NET: \$job_id"
EOF
    assert_script_run($_) foreach (split /\n/, $cmd);
    assert_script_run("retry -- openqa-clone-job --show-progress --from $openqa_url \$job_id", timeout => 120);
    save_screenshot;
    clear_root_console;
}

1;
