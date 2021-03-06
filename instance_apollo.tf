resource "openstack_compute_instance_v2" "apollo-main" {
  name            = "apollo.internal.galaxyproject.eu"
  image_name      = "${var.centos_image}"
  flavor_name     = "m1.large"
  key_pair        = "cloud2"
  security_groups = "${var.sg_webservice}"

  network {
    name = "bioinf"
  }
}

resource "aws_route53_record" "apollo-main" {
  zone_id = "${var.zone_galaxyproject_eu}"
  name    = "apollo.internal.galaxyproject.eu"
  type    = "A"
  ttl     = "7200"
  records = ["${openstack_compute_instance_v2.apollo-main.access_ip_v4}"]
}
