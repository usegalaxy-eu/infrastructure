resource "openstack_compute_instance_v2" "dokku" {
  name            = "apps.galaxyproject.eu"
  image_name      = "Ubuntu 22.04"
  flavor_name     = "m1.xlarge"
  key_pair        = "cloud2"
  security_groups = ["egress", "public-ssh", "public-ping", "public-web2"]

  network {
    name = "public"
  }
}

# 17.4.2024: This resource creation is commented out because the volume
# from the old cloud is being attached to the instance in the new cloud.
# resource "openstack_blockstorage_volume_v3" "dokku-data" {
#   name        = "stats"
#   description = "Data volume for dokku"
#   size        = 50
# }

resource "openstack_compute_volume_attach_v2" "dokku-va" {
  instance_id = openstack_compute_instance_v2.dokku.id
  volume_id   = "6cbce9f7-1ffd-4848-9ec8-0a2ccfd52225"
  device      = "/dev/vdb"
}

resource "aws_route53_record" "dokku-dns" {
  allow_overwrite = true
  zone_id         = var.zone_galaxyproject_eu
  name            = "apps.galaxyproject.eu"
  type            = "A"
  ttl             = "3600"
  records         = ["${openstack_compute_instance_v2.dokku.access_ip_v4}"]
}

resource "aws_route53_record" "dokku-dns-wildcard" {
  allow_overwrite = true
  zone_id         = var.zone_galaxyproject_eu
  name            = "*.apps.galaxyproject.eu"
  type            = "CNAME"
  ttl             = "3600"
  records         = ["apps.galaxyproject.eu"]
}
