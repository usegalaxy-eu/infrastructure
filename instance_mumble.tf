resource "openstack_compute_instance_v2" "mumble-usegalaxy" {
  name            = "mumble.galaxyproject.eu"
  image_name      = "Ubuntu 18.04"
  flavor_name     = "m1.small"
  key_pair        = "cloud2"
  security_groups = "${var.sg_mumble-pubssh}"

  network {
    name = "public"
  }
}

resource "aws_route53_record" "mumble-usegalaxy" {
  zone_id = "${var.zone_galaxyproject_eu}"
  name    = "mumble.galaxyproject.eu"
  type    = "A"
  ttl     = "7200"
  records = ["${openstack_compute_instance_v2.mumble-usegalaxy.access_ip_v4}"]
}
