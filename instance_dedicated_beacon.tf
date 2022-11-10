variable "beacon-count" {
  default = 1
}

data "openstack_images_image_v2" "beacon-image" {
  name = "generic-rockylinux8-v60-j168-5333625af7b2-main"
}

resource "openstack_compute_instance_v2" "beacon" {
  name            = "beacon-${count.index}.galaxyproject.eu"
  image_id        = data.openstack_images_image_v2.beacon-image.id
  flavor_name     = "m1.small"
  key_pair        = "cloud2"
  tags            = []
  security_groups = ["default", "public-web2"]

  network {
    name = "bioinf"
  }

  user_data = <<-EOF
    #cloud-config
    package_update: true
    package_upgrade: true
  EOF

  count = var.beacon-count
}

resource "aws_route53_record" "beacon-galaxyproject" {
  allow_overwrite = true
  zone_id         = var.zone_galaxyproject_eu
  name            = "beacon-${count.index}.galaxyproject.eu"
  type            = "A"
  ttl             = "600"
  records         = ["${element(openstack_compute_instance_v2.beacon.*.access_ip_v4, count.index)}"]
  count           = var.beacon-count
}

resource "openstack_blockstorage_volume_v2" "beacon-vol" {
  name        = "beacon-data-vol-${random_id.beacon-volume_name_unique.hex}"
  volume_type = "default"
  description = "Data volume for beacon VM"
  size        = 128
}

resource "openstack_compute_volume_attach_v2" "beacon-va" {
  instance_id = openstack_compute_instance_v2.beacon.id
  volume_id   = openstack_blockstorage_volume_v2.beacon-vol.id
}