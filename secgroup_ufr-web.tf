resource "openstack_networking_secgroup_v2" "ufr-web" {
  name                 = "ufr-web"
  description          = "[tf] Ingress web (HTTP+HTTPS) connections for UFR networks"
  delete_default_rules = "true"
}

resource "openstack_networking_secgroup_rule_v2" "in-80" {
  direction         = "ingress"
  ethertype         = "IPv4"
  protocol          = "tcp"
  remote_ip_prefix  = "${element(var.netz, count.index)}"
  count             = 2
  port_range_min    = "80"
  port_range_max    = "80"
  security_group_id = "${openstack_networking_secgroup_v2.ufr-web.id}"
}

resource "openstack_networking_secgroup_rule_v2" "in-443" {
  direction = "ingress"
  ethertype = "IPv4"
  protocol  = "tcp"

  # https://blog.gruntwork.io/terraform-tips-tricks-loops-if-statements-and-gotchas-f739bbae55f9?gi=3aa164111a31
  remote_ip_prefix  = "${element(var.netz, count.index)}"
  count             = 2
  port_range_min    = "443"
  port_range_max    = "443"
  security_group_id = "${openstack_networking_secgroup_v2.ufr-web.id}"
}
