resource "openstack_compute_instance_v2" "test-usegalaxy" {
  name            = "test.usegalaxy.eu"
  image_name      = "${var.centos_image}"
  flavor_name     = "c.c20m120"
  key_pair        = "cloud2"
  security_groups = "${var.sg_webservice}"

  network {
    name = "public"
  }
}

resource "aws_route53_record" "test-usegalaxy-ip" {
  zone_id = "${var.zone_usegalaxy_eu}"
  name    = "test.usegalaxy.eu"
  type    = "A"
  ttl     = "7200"
  records = ["${openstack_compute_instance_v2.test-usegalaxy.access_ip_v4}"]
}
