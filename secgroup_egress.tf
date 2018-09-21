resource "openstack_networking_secgroup_v2" "egress" {
  name                 = "egress"
  description          = "[tf] Default egress profile"
  delete_default_rules = "true"
}

resource "openstack_networking_secgroup_rule_v2" "00914113-bb06-4862-84f4-fec30b168565" {
  direction         = "egress"
  ethertype         = "IPv6"
  security_group_id = "${openstack_networking_secgroup_v2.egress.id}"
}

resource "openstack_networking_secgroup_rule_v2" "4a40a325-78a7-4ead-a1fa-4ef66ac512f6" {
  direction         = "egress"
  ethertype         = "IPv4"
  security_group_id = "${openstack_networking_secgroup_v2.egress.id}"
}
