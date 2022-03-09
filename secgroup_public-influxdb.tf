resource "openstack_networking_secgroup_v2" "public-influxdb" {
  name                 = "public-influxdb"
  description          = "[tf] Allow public HTTP(s) connections to port 8086"
  delete_default_rules = "true"
}

resource "openstack_networking_secgroup_rule_v2" "public-influxdb-rule" {
  direction         = "ingress"
  ethertype         = "IPv4"
  protocol          = "tcp"
  remote_ip_prefix  = "0.0.0.0/0"
  port_range_min    = "8086"
  port_range_max    = "8086"
  security_group_id = openstack_networking_secgroup_v2.public-influxdb.id
}
