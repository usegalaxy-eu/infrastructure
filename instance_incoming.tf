variable "incoming-dns" {
  default = "incoming.galaxyproject.eu"
}

resource "openstack_compute_instance_v2" "incoming" {
  name        = "${var.incoming-dns}"
  image_name  = "CentOS 8.3"
  flavor_name = "m1.small"
  key_pair    = "cloud2"

  # TODO: tighten up secgroups
  security_groups = ["egress", "public"]

  network {
    name = "public-extended"
  }
}

resource "aws_route53_record" "incoming" {
  zone_id = "${var.zone_galaxyproject_eu}"
  name    = "${var.incoming-dns}"
  type    = "A"
  ttl     = "600"
  records = ["${openstack_compute_instance_v2.incoming.access_ip_v4}"]
}
