resource "openstack_compute_instance_v2" "build-usegalaxy" {
  name            = "build.galaxyproject.eu"
  image_name      = "${var.centos_image}"
  flavor_name     = "m1.large"
  key_pair        = "cloud2"
  security_groups = "${var.sg_webservice}"

  network {
    name = "public"
  }
}

resource "aws_route53_record" "build-usegalaxy" {
  zone_id = "${var.zone_galaxyproject_eu}"
  name    = "build.galaxyproject.eu"
  type    = "A"
  ttl     = "7200"
  records = ["${openstack_compute_instance_v2.build-usegalaxy.access_ip_v4}"]
}
