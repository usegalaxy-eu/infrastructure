resource "openstack_compute_instance_v2" "apollo-usegalaxy" {
  name            = "apollo.internal.galaxyproject.eu"
  image_name      = "apollo_16_04_2024"
  flavor_name     = "m1.xlarge"
  key_pair        = "cloud2"
  security_groups = ["egress", "public-web2", "public-ssh", "default", "public-ping"]

  network {
    name = "bioinf"
  }

  user_data = <<-EOF
    #cloud-config
    package_update: true
    package_upgrade: true
  EOF
}


resource "aws_route53_record" "apollo-usegalaxy-internal" {
  allow_overwrite = true
  zone_id         = aws_route53_zone.zone_galaxyproject_eu.zone_id
  name            = "apollo.internal.galaxyproject.eu"
  type            = "A"
  ttl             = "600"
  records         = ["${openstack_compute_instance_v2.apollo-usegalaxy.access_ip_v4}"]
}
