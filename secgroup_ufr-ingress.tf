resource "openstack_networking_secgroup_v2" "ufr-ingress" {
  name                 = "ufr-ingress"
  description          = "[tf] Ingress connections from any UFR networks"
  delete_default_rules = "true"
}

resource "openstack_networking_secgroup_rule_v2" "40047dc3-cf90-4d66-ade4-5c281ea03a9c" {
  direction         = "ingress"
  ethertype         = "IPv4"
  remote_ip_prefix  = "192.52.3.0/24"
  security_group_id = "${openstack_networking_secgroup_v2.ufr-ingress.id}"
}

resource "openstack_networking_secgroup_rule_v2" "de4ad9ea-9ee4-4a8c-88ee-cc14410ebada" {
  direction         = "ingress"
  ethertype         = "IPv4"
  remote_ip_prefix  = "132.230.0.0/16"
  security_group_id = "${openstack_networking_secgroup_v2.ufr-ingress.id}"
}

resource "openstack_networking_secgroup_rule_v2" "9725f501-278c-4286-9cae-3ec20d89c724" {
  direction         = "ingress"
  ethertype         = "IPv4"
  remote_ip_prefix  = "192.52.2.0/24"
  security_group_id = "${openstack_networking_secgroup_v2.ufr-ingress.id}"
}

resource "openstack_networking_secgroup_rule_v2" "58293ee9-af20-4f46-8fb2-8760afb10f9a" {
  direction         = "ingress"
  ethertype         = "IPv4"
  remote_ip_prefix  = "10.0.0.0/8"
  security_group_id = "${openstack_networking_secgroup_v2.ufr-ingress.id}"
}
