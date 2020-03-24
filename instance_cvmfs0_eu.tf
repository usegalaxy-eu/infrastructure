resource "openstack_compute_instance_v2" "cvmfs-stratum0-eu" {
  name            = "cvmfs-stratum0.galaxyproject.eu"
  image_name      = "generic-centos7-v31-j41-4ab83d5ffde9-master"
  flavor_name     = "m1.small"
  key_pair        = "cloud2"
  security_groups = "${var.sg_webservice-pubssh}"

  network {
    name = "public-extended"
  }
}

resource "openstack_blockstorage_volume_v2" "cvmfs-data-eu" {
  name        = "cvmfs"
  description = "Data volume for cvmfs"
  size        = 500
}

resource "openstack_compute_volume_attach_v2" "cvmfs-va-eu" {
  instance_id = "${openstack_compute_instance_v2.cvmfs-stratum0-eu.id}"
  volume_id   = "${openstack_blockstorage_volume_v2.cvmfs-data-eu.id}"
}

resource "aws_route53_record" "cvmfs-stratum0-eu" {
  zone_id = "${var.zone_galaxyproject_eu}"
  name    = "cvmfs-stratum0.galaxyproject.eu"
  type    = "A"
  ttl     = "7200"
  records = ["${openstack_compute_instance_v2.cvmfs-stratum0-eu.access_ip_v4}"]
}
