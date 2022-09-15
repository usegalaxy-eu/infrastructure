resource "openstack_compute_instance_v2" "dokku" {
  name            = "apps.galaxyproject.eu"
  image_name      = "generic-rockylinux8-v60-j168-5333625af7b2-main"
  flavor_name     = "m1.xlarge"
  key_pair        = "cloud2"
  security_groups = ["egress", "public-ssh", "public-ping", "public-web2"]

  network {
    name = "public"
  }
}

resource "aws_route53_record" "dokku-dns" {
  allow_overwrite = true
  zone_id         = var.zone_galaxyproject_eu
  name            = "apps.galaxyproject.eu"
  type            = "A"
  ttl             = "3600"
  records         = ["${openstack_compute_instance_v2.dokku.access_ip_v4}"]
}

resource "aws_route53_record" "dokku-dns-wildcard" {
  allow_overwrite = true
  zone_id         = var.zone_galaxyproject_eu
  name            = "*.apps.galaxyproject.eu"
  type            = "CNAME"
  ttl             = "3600"
  records         = ["apps.galaxyproject.eu"]
}
