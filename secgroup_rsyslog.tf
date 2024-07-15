resource "openstack_networking_secgroup_v2" "rsyslog" {
  name                 = "rsyslog"
  description          = "[tf] Rsyslog"
  delete_default_rules = "true"
}

# Allow ingress 514 TCP in 10.5.67.0/24
resource "openstack_networking_secgroup_rule_v2" "rsyslog-tcp" {
  direction         = "ingress"
  ethertype         = "IPv4"
  security_group_id = openstack_networking_secgroup_v2.rsyslog.id
  protocol          = "tcp"
  port_range_min    = 514
  port_range_max    = 514
  remote_ip_prefix  = "10.5.67.0/24"
}

# Allow ingress 514 TCP in 10.5.68.0/24 (ZFS)
resource "openstack_networking_secgroup_rule_v2" "rsyslog-zfs" {
  direction         = "ingress"
  ethertype         = "IPv4"
  security_group_id = openstack_networking_secgroup_v2.rsyslog.id
  protocol          = "tcp"
  port_range_min    = 514
  port_range_max    = 514
  remote_ip_prefix  = "10.5.68.0/24"
}

