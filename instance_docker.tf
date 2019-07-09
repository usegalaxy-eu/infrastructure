resource "openstack_compute_instance_v2" "docker-host" {
  name            = "docker.galaxyproject.eu"
  image_name      = "${var.centos_image_new}"
  flavor_name     = "m1.xxlarge"
  key_pair        = "cloud2"
  security_groups = ["public"]

  network {
    name = "public"
  }
}

resource "aws_route53_record" "docker-host" {
  zone_id = "${var.zone_galaxyproject_eu}"
  name    = "docker.galaxyproject.eu"
  type    = "A"
  ttl     = "7200"
  records = ["${openstack_compute_instance_v2.docker-host.access_ip_v4}"]
}
