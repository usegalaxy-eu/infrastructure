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

resource "aws_route53_record" "incoming" {
  allow_overwrite = true
  zone_id         = var.zone_galaxyproject_eu
  name            = var.incoming-dns
  type            = "A"
  ttl             = "600"
  records         = ["${openstack_compute_instance_v2.incoming.access_ip_v4}"]
}

resource "aws_route53_record" "ftp" {
  allow_overwrite = true
  zone_id         = var.zone_usegalaxy_eu
  name            = "ftp.usegalaxy.eu"
  type            = "A"
  ttl             = "600"
  records         = ["${openstack_compute_instance_v2.incoming.access_ip_v4}"]
}
