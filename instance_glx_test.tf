resource "openstack_compute_instance_v2" "test01" {
  name            = "test01.galaxyproject.eu"
  image_name      = "Ubuntu 18.04"
  flavor_name     = "m1.large"
  key_pair        = "glx-test"
  security_groups = ["egress", "public-ssh", "public-ping", "public-web2"]

  network {
    name = "public"
  }
}

resource "openstack_blockstorage_volume_v2" "test01-data" {
  name        = "test01"
  description = "Data volume for test01"
  size        = 50
}

resource "openstack_compute_volume_attach_v2" "test01-va" {
  instance_id = "${openstack_compute_instance_v2.test01.id}"
  volume_id   = "${openstack_blockstorage_volume_v2.test01-data.id}"
}

resource "aws_route53_record" "test01" {
  zone_id = "${var.zone_galaxyproject_eu}"
  name    = "test01.galaxyproject.eu"
  type    = "A"
  ttl     = "7200"
  records = ["${openstack_compute_instance_v2.test01.access_ip_v4}"]
}

resource "openstack_compute_instance_v2" "test02" {
  name            = "test02.galaxyproject.eu"
  image_name      = "Ubuntu 18.04"
  flavor_name     = "m1.large"
  key_pair        = "glx-test"
  security_groups = ["egress", "public-ssh", "public-ping", "public-web2"]

  network {
    name = "public"
  }
}

resource "aws_route53_record" "test02" {
  zone_id = "${var.zone_galaxyproject_eu}"
  name    = "test02.galaxyproject.eu"
  type    = "A"
  ttl     = "7200"
  records = ["${openstack_compute_instance_v2.test02.access_ip_v4}"]
}
