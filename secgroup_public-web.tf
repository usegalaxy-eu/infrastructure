resource "openstack_networking_secgroup_v2" "public-web" {
  name        = "public-web"
  description = "[tf] Allow public HTTP + HTTPS connections"
}

resource "openstack_networking_secgroup_rule_v2" "5cbd5183-8918-4d74-aa9b-302ebe813d8c" {
  direction         = "ingress"
  ethertype         = "IPv4"
  protocol          = "tcp"
  port_range_min    = "80"
  port_range_max    = "80"
  security_group_id = "${openstack_networking_secgroup_v2.public-web.id}"
}

resource "openstack_networking_secgroup_rule_v2" "ef536597-385f-45b1-8895-f0553595c8fb" {
  direction         = "ingress"
  ethertype         = "IPv4"
  protocol          = "tcp"
  port_range_min    = "443"
  port_range_max    = "443"
  security_group_id = "${openstack_networking_secgroup_v2.public-web.id}"
}

resource "openstack_networking_secgroup_rule_v2" "5cbd5183-8918-4d74-aa9b-302ebe813d8z" {
  direction         = "ingress"
  ethertype         = "IPv6"
  protocol          = "tcp"
  port_range_min    = "80"
  port_range_max    = "80"
  security_group_id = "${openstack_networking_secgroup_v2.public-web.id}"
}

resource "openstack_networking_secgroup_rule_v2" "ef536597-385f-45b1-8895-f0553595c8fz" {
  direction         = "ingress"
  ethertype         = "IPv6"
  protocol          = "tcp"
  port_range_min    = "443"
  port_range_max    = "443"
  security_group_id = "${openstack_networking_secgroup_v2.public-web.id}"
}
