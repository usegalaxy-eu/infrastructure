resource "openstack_networking_secgroup_v2" "egress" {
  name                 = "egress"
  description          = "[tf] Default egress profile"
  delete_default_rules = "true"
}

resource "openstack_networking_secgroup_rule_v2" "egress-ports6" {
  direction         = "egress"
  ethertype         = "IPv6"
  security_group_id = openstack_networking_secgroup_v2.egress.id
}

resource "openstack_networking_secgroup_rule_v2" "egress-ports4" {
  direction         = "egress"
  ethertype         = "IPv4"
  security_group_id = openstack_networking_secgroup_v2.egress.id
}
