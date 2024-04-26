resource "openstack_compute_instance_v2" "plausible-usegalaxy" {
  name            = "plausible.galaxyproject.eu"
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

resource "aws_route53_record" "plausible-usegalaxy" {
  allow_overwrite = true
  zone_id         = var.zone_galaxyproject_eu
  name            = "plausible.galaxyproject.eu"
  type            = "A"
  ttl             = "600"
  records         = ["${openstack_compute_instance_v2.plausible-usegalaxy.access_ip_v4}"]
}
