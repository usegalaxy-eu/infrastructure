resource "openstack_networking_secgroup_v2" "public-irods" {
  name                 = "public-irods"
  description          = "[tf] Allow incoming iRODS connections"
  delete_default_rules = "true"
}

resource "openstack_networking_secgroup_rule_v2" "zone_port-9230b66f-e769-407e-a11f-52b37ebc6b30" {
  direction         = "ingress"
  ethertype         = "IPv4"
  protocol          = "tcp"
  remote_ip_prefix  = "0.0.0.0/0"
  port_range_min    = "1247"
  port_range_max    = "1247"
  security_group_id = "${openstack_networking_secgroup_v2.public-irods.id}"
}

resource "openstack_networking_secgroup_rule_v2" "zone_port-4c32276f-f8b6-45d0-b9aa-8458fe162ba3" {
  direction         = "ingress"
  ethertype         = "IPv6"
  protocol          = "tcp"
  remote_ip_prefix  = "0.0.0.0/0"
  port_range_min    = "1247"
  port_range_max    = "1247"
  security_group_id = "${openstack_networking_secgroup_v2.public-irods.id}"
}
