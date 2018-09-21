resource "openstack_compute_instance_v2" "ftp" {
  name            = "ftp.usegalaxy.eu"
  image_name      = "${var.centos_image}"
  flavor_name     = "m1.small"
  key_pair        = "cloud2"
  security_groups = ["public"]

  network {
    name = "public"
  }
}

resource "aws_route53_record" "ftp" {
  zone_id = "${var.zone_usegalaxy_eu}"
  name    = "ftp.usegalaxy.eu"
  type    = "A"
  ttl     = "300"
  records = ["${openstack_compute_instance_v2.ftp.access_ip_v4}"]
}
