variable "workers-org" {
  default = 2
}

resource "openstack_compute_instance_v2" "jenkins-workers-org" {
  name            = "n${count.index}.galaxyproject.org"
  image_name      = "Ubuntu 18.04"
  flavor_name     = "m1.xxlarge"
  key_pair        = "build-usegalaxy-org"
  security_groups = ["public"]
  count           = "${var.workers-org}"

  network {
    name = "public"
  }
}

resource "aws_route53_record" "jenkins-workers-org" {
  zone_id = "${var.zone_galaxyproject_eu}"
  name    = "n${count.index}.galaxyproject.eu"
  type    = "A"
  ttl     = "7200"
  records = ["${element(openstack_compute_instance_v2.jenkins-workers-org.*.access_ip_v4, count.index)}"]
  count   = "${var.workers-org}"
}

resource "openstack_blockstorage_volume_v2" "jenkins-workers-org-data" {
  name        = "jenkins-org"
  description = "Data volume for Jenkins n${count.index}.galaxyproject.org"
  size        = 200
  count       = "${var.workers-org}"
}

resource "openstack_compute_volume_attach_v2" "jenkins-workers-org-va" {
  instance_id = "${element(openstack_compute_instance_v2.jenkins-workers-org.*.id, count.index)}"
  volume_id   = "${element(openstack_blockstorage_volume_v2.jenkins-workers-org-data.*.id, count.index)}"
  count       = "${var.workers-org}"
}
