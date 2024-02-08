resource "openstack_networking_secgroup_v2" "htcondor_shared_port" {
  name                 = "htcondor_shared_port"
  description          = "[tf] HTCcondor shared port profile"
  delete_default_rules = "true"
}

resource "openstack_networking_secgroup_rule_v2" "htcondor_shared_port_ingress_ipv4" {
  direction         = "ingress"
  ethertype         = "IPv4"
  protocol          = "tcp"
  port_range_min    = "9628"
  port_range_max    = "9628"
  security_group_id = openstack_networking_secgroup_v2.htcondor_shared_port.id
}
