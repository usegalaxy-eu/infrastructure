data "openstack_images_image_v2" "beacon-import-image" {
  # BW Cloud basic Rocky 9 image
  name = "c6906a58-1e05-4be0-8f20-41f24c8320b5"
}

resource "openstack_compute_instance_v2" "beacon-import" {
  name            = "beacon-import.galaxyproject.eu"
  image_id        = data.openstack_images_image_v2.beacon-import-image.id
  flavor_name     = "m1.tiny"
  key_pair        = "cloud2"
  tags            = []
  security_groups = ["default"]

  network {
    name = "bioinf"
  }

  user_data = <<-EOF
    #cloud-config
    package_update: true
    package_upgrade: true
  EOF

}

resource "aws_route53_record" "beacon-import-galaxyproject" {
  allow_overwrite = true
  zone_id         = var.zone_galaxyproject_eu
  name            = "beacon-import.galaxyproject.eu"
  records         = ["${openstack_compute_instance_v2.beacon-import.access_ip_v4}"]
  type            = "A"
  ttl             = "600"
}
