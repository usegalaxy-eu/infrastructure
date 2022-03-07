resource "openstack_networking_secgroup_v2" "public-ftp" {
  name                 = "public-ftp"
  description          = "[tf] Allow FTP connections from anywhere"
  delete_default_rules = "true"
}

resource "openstack_networking_secgroup_rule_v2" "public-ftp-egress-ipv4" {
  direction         = "egress"
  ethertype         = "IPv4"
  protocol          = "tcp"
  port_range_min    = "20"
  port_range_max    = "20"
  security_group_id = openstack_networking_secgroup_v2.public-ftp.id
}

resource "openstack_networking_secgroup_rule_v2" "public-ftp-egress-ipv6" {
  direction         = "egress"
  ethertype         = "IPv6"
  protocol          = "tcp"
  port_range_min    = "20"
  port_range_max    = "20"
  security_group_id = openstack_networking_secgroup_v2.public-ftp.id
}


resource "openstack_networking_secgroup_rule_v2" "public-ftp-ingress-ipv4" {
  direction         = "ingress"
  ethertype         = "IPv4"
  protocol          = "tcp"
  port_range_min    = "20"
  port_range_max    = "21"
  security_group_id = openstack_networking_secgroup_v2.public-ftp.id
}

resource "openstack_networking_secgroup_rule_v2" "public-ftp-ingress-ip4" {
  direction         = "ingress"
  ethertype         = "IPv6"
  protocol          = "tcp"
  port_range_min    = "20"
  port_range_max    = "21"
  security_group_id = openstack_networking_secgroup_v2.public-ftp.id
}

resource "openstack_networking_secgroup_rule_v2" "public-ftp-data-ports-ipv4" {
  direction         = "ingress"
  ethertype         = "IPv4"
  protocol          = "tcp"
  port_range_min    = "49152"
  port_range_max    = "65534"
  security_group_id = openstack_networking_secgroup_v2.public-ftp.id
}

resource "openstack_networking_secgroup_rule_v2" "public-ftp-data-ports-ipv6" {
  direction         = "ingress"
  ethertype         = "IPv6"
  protocol          = "tcp"
  port_range_min    = "49152"
  port_range_max    = "65534"
  security_group_id = openstack_networking_secgroup_v2.public-ftp.id
}
