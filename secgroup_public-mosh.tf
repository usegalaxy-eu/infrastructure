resource "openstack_networking_secgroup_v2" "public-mosh" {
  name                 = "public-mosh"
  description          = "[tf] Rules for mosh servers"
  delete_default_rules = "true"
}

resource "openstack_networking_secgroup_rule_v2" "41156470-b6fb-48d1-950b-bcf17bf64ba2" {
  direction         = "ingress"
  ethertype         = "IPv4"
  protocol          = "tcp"
  remote_ip_prefix  = "0.0.0.0/0"
  port_range_min    = "60000"
  port_range_max    = "61000"
  security_group_id = "${openstack_networking_secgroup_v2.public-mosh.id}"
}
