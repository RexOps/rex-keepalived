#
# (c) Jan Gehring <jan.gehring@gmail.com>
#
# vim: set ts=2 sw=2 tw=0:
# vim: set expandtab:

package Keepalived;

use Rex -feature => ['0.51'];
use Rex::Ext::ParamLookup;

my $packages = { centos => [ "keepalived", "ipvsadm" ], };

task "setup", make {
  my $package_name = param_lookup "package", $packages->{ lc operating_system };

  my $lvs_id = param_lookup "lvs_id", "lv01";
  my $vrrp_sync_group_name = param_lookup "vrrp_sync_group_name", "vg01";
  my $vrrp_instances = param_lookup "vrrp_instances", [];

  pkg $package_name, ensure => present;

  file "/etc/keepalived/keepalived.conf",
    content   => template("templates/keepalived.conf.tpl"),
    owner     => "root",
    group     => "root",
    on_change => make {
    service keepalived => "restart";
    };
};

1;
