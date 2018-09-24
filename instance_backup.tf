resource "openstack_compute_instance_v2" "backup-server" {
  name            = "backup.galaxyproject.eu"
  image_name      = "${var.centos_image}"
  flavor_name     = "m1.tiny"
  key_pair        = "cloud2"
  security_groups = ["egress", "ufr-ssh"]

  network {
    name = "bioinf"
  }
}

resource "aws_route53_record" "backup-server" {
  zone_id = "${var.zone_galaxyproject_eu}"
  name    = "${openstack_compute_instance_v2.backup-server.name}"
  type    = "A"
  ttl     = "7200"
  records = ["${openstack_compute_instance_v2.backup-server.access_ip_v4}"]
}
