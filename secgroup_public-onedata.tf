resource "openstack_networking_secgroup_v2" "public-onedata" {
  name                 = "public-onedata"
  description          = "[tf] Allow public ONEDATA connections (fixed)"
  delete_default_rules = "true"
}

variable "onedata-ports" {
  description = "ONEDATA ports"
  type        = list(string)
  default     = ["53", "80", "443", "9443"]
}

resource "openstack_networking_secgroup_rule_v2" "public-onedata-ports4" {
  direction         = "ingress"
  ethertype         = "IPv4"
  protocol          = "tcp"
  security_group_id = openstack_networking_secgroup_v2.public-onedata.id

  count          = 4
  port_range_min = element(var.onedata-ports, count.index)
  port_range_max = element(var.onedata-ports, count.index)
}

resource "openstack_networking_secgroup_rule_v2" "public-onedata-ports6" {
  direction         = "ingress"
  ethertype         = "IPv6"
  protocol          = "tcp"
  security_group_id = openstack_networking_secgroup_v2.public-onedata.id

  count          = 4
  port_range_min = element(var.onedata-ports, count.index)
  port_range_max = element(var.onedata-ports, count.index)
}

resource "openstack_networking_secgroup_rule_v2" "public-onedata-udp-ports4" {
  direction         = "ingress"
  ethertype         = "IPv4"
  protocol          = "udp"
  security_group_id = openstack_networking_secgroup_v2.public-onedata.id

  count          = 1
  port_range_min = element(var.onedata-ports, count.index)
  port_range_max = element(var.onedata-ports, count.index)
}

resource "openstack_networking_secgroup_rule_v2" "public-onedata-udp-ports6" {
  direction         = "ingress"
  ethertype         = "IPv6"
  protocol          = "udp"
  security_group_id = openstack_networking_secgroup_v2.public-onedata.id

  count          = 1
  port_range_min = element(var.onedata-ports, count.index)
  port_range_max = element(var.onedata-ports, count.index)
}
