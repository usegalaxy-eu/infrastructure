resource "openstack_networking_secgroup_v2" "ufr-influxdb" {
  name                 = "ufr-influxdb"
  description          = "[tf] Allow public HTTP(s) connections to port 8086"
  delete_default_rules = "true"
}

resource "openstack_networking_secgroup_rule_v2" "ufr-influxdb" {
  direction         = "ingress"
  ethertype         = "IPv4"
  protocol          = "tcp"
  port_range_min    = "8086"
  port_range_max    = "8086"
  security_group_id = "${openstack_networking_secgroup_v2.ufr-influxdb.id}"

  remote_ip_prefix = "${element(var.netz, count.index)}"
  count            = "${var.netz_count}"
}
