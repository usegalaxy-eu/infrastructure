variable "cvmfs1-ufr0-eu-dns" {
  default = "cvmfs1-ufr0.internal.galaxyproject.eu"
}

resource "openstack_compute_instance_v2" "cvmfs1-ufr0-eu" {
  name            = var.cvmfs1-ufr0-eu-dns
  image_name      = "cvmfs1-ufr0-internal_22_04_2024"
  flavor_name     = "m1.small"
  key_pair        = "cloud2"
  security_groups = ["egress", "public-ssh", "public-ping", "public-web2"]

  network {
    name = "bioinf"
  }
}

resource "aws_route53_record" "cvmfs1-ufr0-eu" {
  allow_overwrite = true
  zone_id         = aws_route53_zone.zone_galaxyproject_eu.zone_id
  name            = var.cvmfs1-ufr0-eu-dns
  type            = "A"
  ttl             = "600"
  records         = ["${openstack_compute_instance_v2.cvmfs1-ufr0-eu.access_ip_v4}"]
}
