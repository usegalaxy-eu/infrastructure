resource "openstack_compute_instance_v2" "grafana" {
  name            = "stats.galaxyproject.eu"
  image_name      = "vgcn~rockylinux-9-latest-x86_64~+generic+internal~20240820~42312~HEAD~479ec25"
  flavor_name     = "m1.large"
  key_pair        = "cloud2"
  security_groups = ["default", "public-web2"]

  network {
    name = "public-extended"
  }
}

# 17.4.2024: This resource creation is commented out because the volume
# from the old cloud is being attached to the instance in the new cloud.
# Found 2 volumes attached to the instance in the old cloud. So, adding both
# of them here and creating the volume attachment resources below for both.
# resource "openstack_blockstorage_volume_v2" "grafana-data" {
#   name        = "stats"
#   description = "Data volume for Grafana"
#   size        = 2
# }

resource "openstack_compute_volume_attach_v2" "stats-data-vol1" {
  instance_id = openstack_compute_instance_v2.grafana.id
  volume_id   = "ad56f01f-cb21-458c-b1f9-90f937aa6525"
  device      = "/dev/vdb"
}

resource "openstack_compute_volume_attach_v2" "stats-data-vol2" {
  instance_id = openstack_compute_instance_v2.grafana.id
  volume_id   = "254b499b-1293-4341-ba52-2901bbe56fcb"
  device      = "/dev/vdc"
}

resource "aws_route53_record" "grafana-usegalaxy" {
  allow_overwrite = true
  zone_id         = var.zone_galaxyproject_eu
  name            = "stats.galaxyproject.eu"
  type            = "A"
  ttl             = "7200"
  records         = ["${openstack_compute_instance_v2.grafana.access_ip_v4}"]
}

