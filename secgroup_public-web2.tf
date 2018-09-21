resource "openstack_networking_secgroup_v2" "public-web2" {
  name                 = "public-web2"
  description          = "[tf] Allow public HTTP + HTTPS connections (fixed)"
  delete_default_rules = "true"
}

variable "web-ports" {
  description = "Web ports"
  type        = "list"
  default     = ["80", "443", "8080"]
}

resource "openstack_networking_secgroup_rule_v2" "public-web-ports4" {
  direction         = "ingress"
  ethertype         = "IPv4"
  protocol          = "tcp"
  security_group_id = "${openstack_networking_secgroup_v2.public-web2.id}"

  count          = 3
  port_range_min = "${element(var.web-ports, count.index)}"
  port_range_max = "${element(var.web-ports, count.index)}"
}

resource "openstack_networking_secgroup_rule_v2" "public-web-ports6" {
  direction         = "ingress"
  ethertype         = "IPv6"
  protocol          = "tcp"
  security_group_id = "${openstack_networking_secgroup_v2.public-web2.id}"

  count          = 3
  port_range_min = "${element(var.web-ports, count.index)}"
  port_range_max = "${element(var.web-ports, count.index)}"
}
