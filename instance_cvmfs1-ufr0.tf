resource "openstack_compute_instance_v2" "cvmfs1-ufr0-usegalaxy" {
  name            = "cvmfs1-ufr0.galaxyproject.eu"
  image_name      = "${var.centos_image}"
  flavor_name     = "m1.small"
  key_pair        = "cloud2"
  security_groups = "${var.sg_webservice}"

  network {
    name = "public"
  }

  network {
    name = "bioinf"
  }
}

resource "aws_route53_record" "cvmfs1-ufr0-usegalaxy" {
  zone_id = "${var.zone_galaxyproject_eu}"
  name    = "cvmfs1-ufr0.galaxyproject.eu"
  type    = "A"
  ttl     = "7200"
  records = ["${openstack_compute_instance_v2.cvmfs1-ufr0-usegalaxy.access_ip_v4}"]
}
