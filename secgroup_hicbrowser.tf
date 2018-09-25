resource "openstack_networking_secgroup_v2" "hicbrowser" {
  name                 = "hicbrowser"
  description          = "[tf] Allow public HTTP + HTTPS connections"
  delete_default_rules = "true"
}

variable "hic-ports" {
  description = "Web ports"
  type        = "list"
  default     = ["80", "443", "8080", "8081"]
}

resource "openstack_networking_secgroup_rule_v2" "hic-ports4" {
  direction         = "ingress"
  ethertype         = "IPv4"
  protocol          = "tcp"
  security_group_id = "${openstack_networking_secgroup_v2.hicbrowser.id}"

  count          = 4
  port_range_min = "${element(var.hic-ports, count.index)}"
  port_range_max = "${element(var.hic-ports, count.index)}"
}

resource "openstack_networking_secgroup_rule_v2" "hic-ports6" {
  direction         = "ingress"
  ethertype         = "IPv6"
  protocol          = "tcp"
  security_group_id = "${openstack_networking_secgroup_v2.hicbrowser.id}"

  count          = 4
  port_range_min = "${element(var.hic-ports, count.index)}"
  port_range_max = "${element(var.hic-ports, count.index)}"
}
