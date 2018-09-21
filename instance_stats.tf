resource "openstack_compute_instance_v2" "stats-usegalaxy" {
  name            = "stats.galaxyproject.eu"
  image_name      = "${var.centos_image}"
  flavor_name     = "m1.small"
  key_pair        = "cloud2"
  security_groups = "${var.sg_webservice}"

  network {
    name = "public"
  }
}

resource "openstack_blockstorage_volume_v2" "stats-data" {
  name        = "stats"
  description = "Data volume for Grafana"
  size        = 2
}

resource "openstack_compute_volume_attach_v2" "stats-va" {
  instance_id = "${openstack_compute_instance_v2.stats-usegalaxy.id}"
  volume_id   = "${openstack_blockstorage_volume_v2.stats-data.id}"
}

resource "aws_route53_record" "stats-usegalaxy" {
  zone_id = "${var.zone_galaxyproject_eu}"
  name    = "stats.galaxyproject.eu"
  type    = "A"
  ttl     = "7200"
  records = ["${openstack_compute_instance_v2.stats-usegalaxy.access_ip_v4}"]
}
