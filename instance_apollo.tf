resource "openstack_compute_instance_v2" "apollo-usegalaxy" {
  name            = "apollo.usegalaxy.eu"
  image_name      = "${var.centos_image}"
  flavor_name     = "m1.large"
  key_pair        = "cloud2"
  security_groups = "${var.sg_webservice}"

  network {
    name = "bioinf"
  }
}

resource "aws_route53_record" "apollo-usegalaxy" {
  zone_id = "${var.zone_usegalaxy_eu}"
  name    = "apollo.usegalaxy.eu"
  type    = "A"
  ttl     = "7200"
  records = ["${openstack_compute_instance_v2.apollo-usegalaxy.access_ip_v4}"]
}
