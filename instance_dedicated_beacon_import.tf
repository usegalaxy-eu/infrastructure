data "openstack_images_image_v2" "beacon-import-image" {
  name = "generic-rockylinux8-v60-j168-5333625af7b2-main"
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
  records         = ["${openstack_compute_instance_v2.beacon-import.access_ip_v4.test12}"]
  type            = "A"
  ttl             = "600"
}
