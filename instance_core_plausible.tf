resource "openstack_compute_instance_v2" "plausible-usegalaxy-old" {
  # Back-up instance, to be removed after migration to an instance
  # with a larger disk is complete and tested.
  name            = "plausible-old.galaxyproject.eu"
  image_name      = "plausible_16_04_2024"
  flavor_name     = "m1.large"
  key_pair        = "cloud2"
  security_groups = ["egress", "public-web2", "public-ftp", "default", "public-ping"]

  network {
    name = "public"
  }

  user_data = <<-EOF
    #cloud-config
    package_update: true
    package_upgrade: true
  EOF
}

data "openstack_images_image_v2" "plausible-image" {
  name = "plausible_16_04_2024"
}

resource "openstack_compute_instance_v2" "plausible-usegalaxy" {
  name            = "plausible.galaxyproject.eu"
  flavor_name     = "m1.large"
  key_pair        = "cloud2"
  security_groups = ["egress", "public-web2", "public-ftp", "default", "public-ping"]

  network {
    name = "public"
  }

  user_data = <<-EOF
    #cloud-config
    package_update: true
    package_upgrade: true
  EOF

  block_device {
    uuid                  = data.openstack_images_image_v2.plausible-image.id
    source_type           = "image"
    destination_type      = "volume"
    boot_index            = 0
    volume_size           = 35
    delete_on_termination = true
  }
}

resource "aws_route53_record" "plausible-usegalaxy" {
  allow_overwrite = true
  zone_id         = var.zone_galaxyproject_eu
  name            = "plausible.galaxyproject.eu"
  type            = "A"
  ttl             = "600"
  records         = ["${openstack_compute_instance_v2.plausible-usegalaxy-old.access_ip_v4}"]
}
