variable "incoming-dns" {
  default = "incoming.galaxyproject.eu"
}

resource "openstack_compute_instance_v2" "incoming" {
  name        = var.incoming-dns
  image_name  = "generic-rockylinux8-v60-j167-5f3adb0e100c-main"
  flavor_name = "m1.small"
  key_pair    = "cloud2"

  security_groups = ["egress", "public-ssh", "public-web2", "public-ftp"]

  network {
    name = "public-extended"
  }
}

resource "openstack_compute_floatingip_associate_v2" "fipa_incoming" {
  floating_ip = openstack_networking_floatingip_v2.fip_1.address
  instance_id = openstack_compute_instance_v2.incoming.id
}

resource "aws_route53_record" "incoming" {
  zone_id = var.zone_galaxyproject_eu
  name    = var.incoming-dns
  type    = "A"
  ttl     = "600"
  records = ["${openstack_compute_instance_v2.incoming.access_ip_v4}"]
}
