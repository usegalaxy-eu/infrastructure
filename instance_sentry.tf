resource "openstack_compute_instance_v2" "sentry-usegalaxy" {
  name            = "sentry.galaxyproject.eu"
  image_name      = "${var.centos_image}"
  flavor_name     = "m1.small"
  key_pair        = "cloud2"
  security_groups = "${var.sg_webservice}"

  network {
    name = "public"
  }
}

resource "openstack_blockstorage_volume_v2" "sentry-data" {
  name        = "sentry"
  description = "Data volume for Sentry"
  size        = 10
}

resource "openstack_compute_volume_attach_v2" "sentry-va" {
  instance_id = "${openstack_compute_instance_v2.sentry-usegalaxy.id}"
  volume_id   = "${openstack_blockstorage_volume_v2.sentry-data.id}"
}

resource "aws_route53_record" "sentry-usegalaxy" {
  zone_id = "${var.zone_galaxyproject_eu}"
  name    = "sentry.galaxyproject.eu"
  type    = "A"
  ttl     = "7200"
  records = ["${openstack_compute_instance_v2.sentry-usegalaxy.access_ip_v4}"]
}
