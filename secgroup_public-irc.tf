resource "openstack_networking_secgroup_v2" "public-irc" {
  name                 = "public-irc"
  description          = "[tf] Allow incoming IRC connections"
  delete_default_rules = "true"
}

resource "openstack_networking_secgroup_rule_v2" "6179ae32-e3c4-4a8c-a05a-a45bdd7872f3" {
  direction         = "ingress"
  ethertype         = "IPv4"
  protocol          = "tcp"
  remote_ip_prefix  = "0.0.0.0/0"
  port_range_min    = "6667"
  port_range_max    = "6667"
  security_group_id = "${openstack_networking_secgroup_v2.public-irc.id}"
}
