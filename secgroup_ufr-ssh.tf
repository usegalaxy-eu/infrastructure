resource "openstack_networking_secgroup_v2" "ufr-ssh" {
  name                 = "ufr-ssh"
  description          = "[tf] Ingress SSH connections for UFR networks (e.g. combine with public-web/public-ping)"
  delete_default_rules = "true"
}

resource "openstack_networking_secgroup_rule_v2" "83c664a8-ea59-4751-9002-2b41e9b16562" {
  direction         = "ingress"
  ethertype         = "IPv4"
  protocol          = "tcp"
  remote_ip_prefix  = "192.52.2.0/24"
  port_range_min    = "22"
  port_range_max    = "22"
  security_group_id = "${openstack_networking_secgroup_v2.ufr-ssh.id}"
}

resource "openstack_networking_secgroup_rule_v2" "f439304c-6258-42de-824c-293ac6b7729c" {
  direction         = "ingress"
  ethertype         = "IPv4"
  protocol          = "tcp"
  remote_ip_prefix  = "192.52.3.0/24"
  port_range_min    = "22"
  port_range_max    = "22"
  security_group_id = "${openstack_networking_secgroup_v2.ufr-ssh.id}"
}

resource "openstack_networking_secgroup_rule_v2" "27112953-8082-4a9a-8726-eeb6d9c86b79" {
  direction         = "ingress"
  ethertype         = "IPv4"
  protocol          = "tcp"
  remote_ip_prefix  = "132.230.0.0/16"
  port_range_min    = "22"
  port_range_max    = "22"
  security_group_id = "${openstack_networking_secgroup_v2.ufr-ssh.id}"
}

resource "openstack_networking_secgroup_rule_v2" "4e0fa016-2dc2-488c-973f-27543158e95a" {
  direction         = "ingress"
  ethertype         = "IPv4"
  protocol          = "tcp"
  remote_ip_prefix  = "10.0.0.0/8"
  port_range_min    = "22"
  port_range_max    = "22"
  security_group_id = "${openstack_networking_secgroup_v2.ufr-ssh.id}"
}
