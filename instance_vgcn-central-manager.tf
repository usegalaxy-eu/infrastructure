resource "openstack_compute_instance_v2" "vgcn-cm" {
  name            = "manager.vgcn.galaxyproject.eu"
  image_name      = "${var.vgcn_image}"
  flavor_name     = "m1.small"
  key_pair        = "cloud2"
  security_groups = ["public"]

  network {
    name = "bioinf"
  }

  user_data = "${file("conf/cm.yml")}"
}

resource "aws_route53_record" "vgcn-cm" {
  zone_id = "${var.zone_galaxyproject_eu}"
  name    = "manager.vgcn.galaxyproject.eu"
  type    = "A"
  ttl     = "300"
  records = ["${openstack_compute_instance_v2.vgcn-cm.access_ip_v4}"]
}
