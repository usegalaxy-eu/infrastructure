resource "openstack_networking_secgroup_v2" "ingress-from-proxy" {
  name                 = "ingress-from-proxy"
  description          = "[tf] Ingress from proxy"
  delete_default_rules = "true"
}

resource "openstack_networking_secgroup_rule_v2" "ingress-from-proxy_ingress" {
  direction         = "ingress"
  ethertype         = "IPv4"
  security_group_id = openstack_networking_secgroup_v2.ingress-from-proxy.id
  protocol          = "tcp"
  port_range_min    = 5555
  port_range_max    = 5555
  remote_ip_prefix  = "132.230.103.37/32"
}

resource "openstack_networking_secgroup_rule_v2" "ingress-from-proxy_egress_ports6" {
  direction         = "egress"
  ethertype         = "IPv6"
  security_group_id = openstack_networking_secgroup_v2.ingress-from-proxy.id
}

resource "openstack_networking_secgroup_rule_v2" "ingress-from-proxy_egress_ports4" {
  direction         = "egress"
  ethertype         = "IPv4"
  security_group_id = openstack_networking_secgroup_v2.ingress-from-proxy.id
}
