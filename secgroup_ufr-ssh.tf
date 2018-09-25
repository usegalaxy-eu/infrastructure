resource "openstack_networking_secgroup_v2" "ufr-ssh" {
  name                 = "ufr-ssh"
  description          = "[tf] Ingress SSH connections for UFR networks (e.g. combine with public-web/public-ping)"
  delete_default_rules = "true"
}

resource "openstack_networking_secgroup_rule_v2" "ufr-ssh" {
  direction = "ingress"
  ethertype = "IPv4"
  protocol  = "tcp"

  remote_ip_prefix  = "${element(var.netz, count.index)}"
  count             = "${var.netz_count}"
  port_range_min    = "22"
  port_range_max    = "22"
  security_group_id = "${openstack_networking_secgroup_v2.ufr-ssh.id}"
}
