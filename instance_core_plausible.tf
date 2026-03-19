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

moved {
  from = openstack_compute_instance_v2.plausible-usegalaxy
  to   = openstack_compute_instance_v2.plausible-usegalaxy-old
}

resource "aws_route53_record" "plausible-usegalaxy" {
  allow_overwrite = true
  zone_id         = var.zone_galaxyproject_eu
  name            = "plausible.galaxyproject.eu"
  type            = "A"
  ttl             = "600"
  records         = ["${openstack_compute_instance_v2.plausible-usegalaxy-old.access_ip_v4}"]
}
