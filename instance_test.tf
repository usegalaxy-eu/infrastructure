resource "openstack_compute_instance_v2" "martenson-test" {
  name            = "martenson-test"
  image_name      = "${var.centos_image_new}"
  flavor_name     = "m1.small"
  key_pair        = "martenson"
  security_groups = "${var.sg_webservice-pubssh}"

  network {
    name = "public"
  }
}

resource "aws_route53_record" "martenson-test" {
  zone_id = "${var.zone_galaxyproject_eu}"
  name    = "martenson-test.galaxyproject.eu"
  type    = "A"
  ttl     = "7200"
  records = ["${openstack_compute_instance_v2.martenson-test.access_ip_v4}"]
}
