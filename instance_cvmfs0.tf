resource "openstack_compute_instance_v2" "cvmfs-stratum0" {
  name            = "cvmfs0.galaxyproject.eu"
  image_name      = "${var.centos_image_new}"
  flavor_name     = "m1.small"
  key_pair        = "cloud2"
  security_groups = "${var.sg_webservice}"

  network {
    name = "public"
  }
}

resource "openstack_blockstorage_volume_v2" "cvmfs-data" {
  name        = "cvmfs"
  description = "Data volume for cvmfs"
  size        = 50
}

resource "openstack_compute_volume_attach_v2" "cvmfs-va" {
  instance_id = "${openstack_compute_instance_v2.cvmfs-stratum0.id}"
  volume_id   = "${openstack_blockstorage_volume_v2.cvmfs-data.id}"
}

resource "aws_route53_record" "cvmfs-stratum0" {
  zone_id = "${var.zone_galaxyproject_eu}"
  name    = "cvmfs-stratum0-test.galaxyproject.eu"
  type    = "A"
  ttl     = "7200"
  records = ["${openstack_compute_instance_v2.cvmfs-stratum0.access_ip_v4}"]
}
