resource "openstack_compute_instance_v2" "grafana" {
  name            = "stats.galaxyproject.eu"
  image_name      = "generic-rockylinux8-v60-j167-5f3adb0e100c-main"
  flavor_name     = "m1.small"
  key_pair        = "cloud2"
  security_groups = ["egress", "public-ssh", "public-ping", "public-web2"]

  network {
    name = "public"
  }
}

resource "openstack_blockstorage_volume_v2" "grafana-data" {
  name        = "stats"
  description = "Data volume for Grafana"
  size        = 2
}

resource "openstack_compute_volume_attach_v2" "stats-va" {
  instance_id = openstack_compute_instance_v2.grafana.id
  volume_id   = openstack_blockstorage_volume_v2.grafana-data.id
}

resource "aws_route53_record" "grafana-usegalaxy" {
  allow_overwrite = true
  zone_id         = var.zone_galaxyproject_eu
  name            = "stats.galaxyproject.eu"
  type            = "A"
  ttl             = "7200"
  records         = ["${openstack_compute_instance_v2.grafana.access_ip_v4}"]
}
