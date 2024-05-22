resource "openstack_networking_secgroup_v2" "interactive-egress" {
  name                 = "interactive-egress"
  description          = "[tf] Interactive egress profile for compute nodes"
  delete_default_rules = "true"
}

resource "openstack_networking_secgroup_rule_v2" "interactive-egress-ftp" {
  direction         = "egress"
  ethertype         = "IPv4"
  security_group_id = openstack_networking_secgroup_v2.interactive-egress.id
  protocol          = "tcp"
  port_range_min    = 21
  port_range_max    = 21
}

resource "openstack_networking_secgroup_rule_v2" "interactive-egress-http" {
  direction         = "egress"
  ethertype         = "IPv4"
  security_group_id = openstack_networking_secgroup_v2.interactive-egress.id
  protocol          = "tcp"
  port_range_min    = 80
  port_range_max    = 80
}

resource "openstack_networking_secgroup_rule_v2" "interactive-egress-https" {
  direction         = "egress"
  ethertype         = "IPv4"
  security_group_id = openstack_networking_secgroup_v2.interactive-egress.id
  protocol          = "tcp"
  port_range_min    = 443
  port_range_max    = 443
}

resource "openstack_networking_secgroup_rule_v2" "interactive-egress-high-ports" {
  direction         = "egress"
  ethertype         = "IPv4"
  security_group_id = openstack_networking_secgroup_v2.interactive-egress.id
  protocol          = "tcp"
  port_range_min    = 1024
  port_range_max    = 65535
}

resource "openstack_networking_secgroup_rule_v2" "interactive-egress-dns" {
  direction         = "egress"
  ethertype         = "IPv4"
  security_group_id = openstack_networking_secgroup_v2.interactive-egress.id
  protocol          = "udp"
  port_range_min    = 53
  port_range_max    = 53
}

resource "openstack_networking_secgroup_rule_v2" "interactive-egress-baremetal" {
  direction         = "egress"
  ethertype         = "IPv4"
  security_group_id = openstack_networking_secgroup_v2.interactive-egress.id
  remote_ip_prefix  = "132.230.223.0/24"
}

resource "openstack_networking_secgroup_rule_v2" "interactive-egress-isilon" {
  direction         = "egress"
  ethertype         = "IPv4"
  security_group_id = openstack_networking_secgroup_v2.interactive-egress.id
  remote_ip_prefix  = "10.4.7.0/24"
}

resource "openstack_networking_secgroup_rule_v2" "interactive-egress-denbi-bwsfs" {
  direction         = "egress"
  ethertype         = "IPv4"
  security_group_id = openstack_networking_secgroup_v2.interactive-egress.id
  remote_ip_prefix  = "10.5.68.0/24"
}

resource "openstack_networking_secgroup_rule_v2" "interactive-egress-ncbi-sra-subnet1" {
  direction         = "egress"
  ethertype         = "IPv4"
  security_group_id = openstack_networking_secgroup_v2.interactive-egress.id
  remote_ip_prefix  = "130.14.0.0/16"
}

resource "openstack_networking_secgroup_rule_v2" "interactive-egress-ncbi-sra-subnet2" {
  direction         = "egress"
  ethertype         = "IPv4"
  security_group_id = openstack_networking_secgroup_v2.interactive-egress.id
  remote_ip_prefix  = "165.112.7.0/24"
}

resource "openstack_networking_secgroup_rule_v2" "interactive-egress-ncbi-sra-subnet3" {
  direction         = "egress"
  ethertype         = "IPv4"
  security_group_id = openstack_networking_secgroup_v2.interactive-egress.id
  remote_ip_prefix  = "165.112.9.0/24"
}


resource "openstack_networking_secgroup_rule_v2" "interactive-egress-ncbi-sra-subnet4" {
  direction         = "egress"
  ethertype         = "IPv4"
  security_group_id = openstack_networking_secgroup_v2.interactive-egress.id
  remote_ip_prefix  = "193.62.193.0/24"
}


resource "openstack_networking_secgroup_rule_v2" "interactive-egress-cems-ftp" {
  direction         = "egress"
  ethertype         = "IPv4"
  security_group_id = openstack_networking_secgroup_v2.interactive-egress.id
  remote_ip_prefix  = "80.158.0.0/16"
}

resource "openstack_networking_secgroup_rule_v2" "interactive-egress-embl-ebi-ftp" {
  direction         = "egress"
  ethertype         = "IPv4"
  security_group_id = openstack_networking_secgroup_v2.interactive-egress.id
  remote_ip_prefix  = "193.62.193.138/32"
}
