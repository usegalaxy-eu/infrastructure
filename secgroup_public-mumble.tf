resource "openstack_networking_secgroup_v2" "public-mumble" {
  name                 = "public-mumble"
  description          = "[tf] Allow incoming MUMBLE connections"
  delete_default_rules = "true"
}

resource "openstack_networking_secgroup_rule_v2" "23018ae7-1e66-4533-b446-8b8ec465d298" {
  direction         = "ingress"
  ethertype         = "IPv4"
  protocol          = "tcp"
  remote_ip_prefix  = "0.0.0.0/0"
  port_range_min    = "64738"
  port_range_max    = "64738"
  security_group_id = "${openstack_networking_secgroup_v2.public-mumble.id}"
}

resource "openstack_networking_secgroup_rule_v2" "e0a7a88f-9570-4030-a39b-17e782b925e0" {
  direction         = "ingress"
  ethertype         = "IPv4"
  protocol          = "udp"
  remote_ip_prefix  = "0.0.0.0/0"
  port_range_min    = "64738"
  port_range_max    = "64738"
  security_group_id = "${openstack_networking_secgroup_v2.public-mumble.id}"
}
