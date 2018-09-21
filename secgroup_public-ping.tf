resource "openstack_networking_secgroup_v2" "public-ping" {
  name                 = "public-ping"
  description          = "[tf] Allow pinging the node to the public"
  delete_default_rules = "true"
}

resource "openstack_networking_secgroup_rule_v2" "b650820a-0a7e-4ba8-ba2b-f14656b9388d" {
  direction         = "ingress"
  ethertype         = "IPv4"
  protocol          = "icmp"
  security_group_id = "${openstack_networking_secgroup_v2.public-ping.id}"
}
