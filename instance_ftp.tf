resource "openstack_compute_instance_v2" "ftp" {
  name        = "ftp.internal.usegalaxy.eu"
  image_name  = "${var.centos_image_new}"
  flavor_name = "m1.small"
  key_pair    = "cloud2"

  # TODO: tighten up secgroups
  security_groups = ["egress", "public"]

  network {
    name = "bioinf"
  }
}

resource "aws_route53_record" "ftp" {
  zone_id = "${var.zone_galaxyproject_eu}"
  name    = "ftp.internal.galaxyproject.eu"
  type    = "A"
  ttl     = "7200"
  records = ["${openstack_compute_instance_v2.ftp.access_ip_v4}"]
}

resource "aws_route53_record" "ftp" {
  zone_id = "${var.zone_usegalaxy_eu}"
  name    = "ftp.usegalaxy.eu"
  type    = "CNAME"
  ttl     = "7200"
  records = ["${openstack_compute_instance_v2.proxy-internal.access_ip_v4}"]
}
