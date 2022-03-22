resource "openstack_networking_secgroup_v2" "public-onedata2" {
  name                 = "public-onedata2"
  description          = "[tf] Allow public ONEDATA connections (fixed)"
  delete_default_rules = "true"
}

variable "onedata2-ports-range-min" {
  description = "ONEDATA ports"
  type        = list(string)
  default     = ["8092", "11207", "11209", "18091", "21100"]
}

variable "onedata2-ports-range-max" {
  description = "ONEDATA ports"
  type        = list(string)
  default     = ["8092", "11207", "11211", "18092", "21299"]
}

resource "openstack_networking_secgroup_rule_v2" "public-onedata2-ports4" {
  direction         = "ingress"
  ethertype         = "IPv4"
  protocol          = "tcp"
  security_group_id = openstack_networking_secgroup_v2.public-onedata2.id

  count          = 5
  port_range_min = element(var.onedata2-ports-range-min, count.index)
  port_range_max = element(var.onedata2-ports-range-max, count.index)
}

resource "openstack_networking_secgroup_rule_v2" "public-onedata2-ports6" {
  direction         = "ingress"
  ethertype         = "IPv6"
  protocol          = "tcp"
  security_group_id = openstack_networking_secgroup_v2.public-onedata2.id

  count          = 5
  port_range_min = element(var.onedata2-ports-range-min, count.index)
  port_range_max = element(var.onedata2-ports-range-max, count.index)
}

