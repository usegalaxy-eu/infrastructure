resource "openstack_compute_instance_v2" "bioconda-utils" {
  name            = "bioconda-utils.galaxyproject.eu"
  image_name      = "Ubuntu 18.04"
  flavor_name     = "m1.medium"
  key_pair        = "bioconda-utils"
  security_groups = "${var.sg_webservice-pubssh}"

  network {
    name = "public"
  }
}

resource "aws_route53_record" "bioconda-utils" {
  zone_id = "${var.zone_galaxyproject_eu}"
  name    = "bioconda-utils.galaxyproject.eu"
  type    = "A"
  ttl     = "7200"
  records = ["${openstack_compute_instance_v2.bioconda-utils.access_ip_v4}"]
}
