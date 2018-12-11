resource "openstack_compute_instance_v2" "test-galaxy" {
  name            = "test.internal.usegalaxy.eu"
  image_name      = "${var.centos_image}"
  flavor_name     = "m1.large"
  key_pair        = "cloud2"
  security_groups = "${var.sg_webservice-pubssh}"

  network {
    name = "bioinf"
  }
}

resource "aws_route53_record" "test-galaxy" {
  zone_id = "${var.zone_usegalaxy_eu}"
  name    = "test.internal.usegalaxy.eu"
  type    = "A"
  ttl     = "600"
  records = ["${openstack_compute_instance_v2.test-galaxy.access_ip_v4}"]
}
