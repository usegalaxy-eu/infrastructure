resource "openstack_networking_secgroup_v2" "public-gat" {
  name                 = "public-gat"
  description          = "[tf] Allow incoming GAT connections"
  delete_default_rules = "true"
}

resource "openstack_networking_secgroup_rule_v2" "public-gat-6789" {
  direction         = "ingress"
  ethertype         = "IPv4"
  protocol          = "tcp"
  remote_ip_prefix  = "0.0.0.0/0"
  port_range_min    = "6789"
  port_range_max    = "6789"
  security_group_id = "${openstack_networking_secgroup_v2.public-gat.id}"
}
