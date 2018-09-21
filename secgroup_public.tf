resource "openstack_networking_secgroup_v2" "Public" {
  name                 = "public"
  description          = "[tf] Completely public machine (ingress + egress)"
  delete_default_rules = "true"
}

resource "openstack_networking_secgroup_rule_v2" "e79fa4e2-bca0-42b4-b864-67e6a750dbe8" {
  direction         = "ingress"
  ethertype         = "IPv4"
  protocol          = "tcp"
  remote_ip_prefix  = "0.0.0.0/0"
  port_range_min    = "1"
  port_range_max    = "65535"
  security_group_id = "${openstack_networking_secgroup_v2.Public.id}"
}

resource "openstack_networking_secgroup_rule_v2" "05135b3c-2cbf-4892-a5c6-f95bb539beb1" {
  direction         = "ingress"
  ethertype         = "IPv4"
  protocol          = "tcp"
  remote_ip_prefix  = "0.0.0.0/0"
  port_range_min    = "3389"
  port_range_max    = "3389"
  security_group_id = "${openstack_networking_secgroup_v2.Public.id}"
}

resource "openstack_networking_secgroup_rule_v2" "81cece52-6293-47de-8bc2-502e16efa9dc" {
  direction         = "egress"
  ethertype         = "IPv6"
  security_group_id = "${openstack_networking_secgroup_v2.Public.id}"
}

resource "openstack_networking_secgroup_rule_v2" "c1b291ec-0147-4022-bcae-0af6cb390f78" {
  direction         = "egress"
  ethertype         = "IPv4"
  security_group_id = "${openstack_networking_secgroup_v2.Public.id}"
}

resource "openstack_networking_secgroup_rule_v2" "da697705-5849-492a-902e-b62f4e9a8377" {
  direction         = "ingress"
  ethertype         = "IPv4"
  protocol          = "tcp"
  remote_ip_prefix  = "0.0.0.0/0"
  port_range_min    = "22"
  port_range_max    = "22"
  security_group_id = "${openstack_networking_secgroup_v2.Public.id}"
}

resource "openstack_networking_secgroup_rule_v2" "e01d7f4e-367e-453f-b716-3dca578d669d" {
  direction         = "ingress"
  ethertype         = "IPv4"
  protocol          = "tcp"
  remote_ip_prefix  = "0.0.0.0/0"
  port_range_min    = "80"
  port_range_max    = "80"
  security_group_id = "${openstack_networking_secgroup_v2.Public.id}"
}
