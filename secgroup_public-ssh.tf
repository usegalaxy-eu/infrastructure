resource "openstack_networking_secgroup_v2" "public-ssh" {
  name                 = "public-ssh"
  description          = "[tf] Allow SSH connections from anywhere"
  delete_default_rules = "true"
}

resource "openstack_networking_secgroup_rule_v2" "aa57e62d-6644-40fb-ad6f-05b50e14bb54" {
  direction         = "ingress"
  ethertype         = "IPv4"
  protocol          = "tcp"
  port_range_min    = "22"
  port_range_max    = "22"
  security_group_id = "${openstack_networking_secgroup_v2.public-ssh.id}"
}

resource "openstack_networking_secgroup_rule_v2" "69bda1a1-67d2-4999-b14a-573ead46073c" {
  direction         = "ingress"
  ethertype         = "IPv6"
  protocol          = "tcp"
  port_range_min    = "22"
  port_range_max    = "22"
  security_group_id = "${openstack_networking_secgroup_v2.public-ssh.id}"
}
