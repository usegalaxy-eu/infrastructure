resource "openstack_compute_instance_v2" "proxy" {
  name            = "proxy.galaxyproject.eu"
  image_name      = "${var.centos_image}"
  flavor_name     = "m1.small"
  key_pair        = "cloud2"
  security_groups = ["egress", "public-ssh", "public-ping", "public-web2", "public-amqp"]

  network {
    name = "public"
  }
}

resource "aws_route53_record" "proxy" {
  zone_id = "${var.zone_galaxyproject_eu}"
  name    = "proxy.galaxyproject.eu"
  type    = "A"
  ttl     = "300"
  records = ["${openstack_compute_instance_v2.proxy.access_ip_v4}"]
}

resource "openstack_compute_instance_v2" "proxy-internal" {
  name            = "proxy.internal.galaxyproject.eu"
  image_name      = "${var.centos_image}"
  flavor_name     = "m1.small"
  key_pair        = "cloud2"
  security_groups = "${var.sg_webservice-pubssh}"

  network {
    name = "public-extended"
  }
}

resource "aws_route53_record" "proxy-internal" {
  zone_id = "${var.zone_galaxyproject_eu}"
  name    = "proxy.internal.galaxyproject.eu"
  type    = "A"
  ttl     = "7200"
  records = ["${openstack_compute_instance_v2.proxy-internal.access_ip_v4}"]
}
