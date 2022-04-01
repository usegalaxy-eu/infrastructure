variable "proxy-dns" {
  default = "proxy.galaxyproject.eu"
}

resource "openstack_compute_instance_v2" "proxy" {
  name            = var.proxy-dns
  image_name      = "generic-rockylinux8-v60-j168-5333625af7b2-main"
  flavor_name     = "m1.small"
  key_pair        = "cloud2"
  security_groups = ["egress", "public-ssh", "public-ping", "public-web2"]

  network {
    name = "public-extended"
  }
}

resource "aws_route53_record" "proxy-internal" {
  allow_overwrite = true
  zone_id         = var.zone_galaxyproject_eu
  name            = "proxy.internal.galaxyproject.eu"
  type            = "A"
  ttl             = "7200"
  records         = ["${openstack_compute_instance_v2.proxy.access_ip_v4}"]
}

resource "aws_route53_record" "proxy" {
  allow_overwrite = true
  zone_id         = var.zone_galaxyproject_eu
  name            = var.proxy-dns
  type            = "A"
  ttl             = "600"
  records         = ["${openstack_compute_instance_v2.proxy.access_ip_v4}"]
}
