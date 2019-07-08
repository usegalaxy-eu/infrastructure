resource "openstack_compute_instance_v2" "jenkins-workers" {
  name            = "worker-${count.index}.build.galaxyproject.eu"
  image_name      = "${var.jenkins_image}"
  flavor_name     = "m1.xlarge"
  key_pair        = "build-usegalaxy-eu"
  security_groups = ["public"]
  count           = 2

  network {
    name = "public"
  }
}

resource "openstack_compute_instance_v2" "jenkins-workers-internal" {
  name            = "worker-internal-${count.index}.build.galaxyproject.eu"
  image_name      = "${var.jenkins_image}"
  flavor_name     = "m1.xlarge"
  key_pair        = "build-usegalaxy-eu"
  security_groups = ["public"]
  count           = 1

  network {
    name = "public-extended"
  }
}

resource "openstack_compute_instance_v2" "jenkins-workers-org" {
  name            = "n${count.index}.galaxyproject.org"
  image_name      = "Ubuntu 18.04"
  flavor_name     = "m1.xxlarge"
  key_pair        = "build-usegalaxy-org"
  security_groups = ["public"]
  count           = 2

  network {
    name = "public"
  }
}

resource "openstack_blockstorage_volume_v2" "jenkins-workers-org-data" {
  name        = "jenkins-org"
  description = "Data volume for Jenkins @ usegalaxy.org"
  size        = 200
  count       = 2
}

resource "openstack_compute_volume_attach_v2" "jenkins-workers-org-va" {
  instance_id = ["${element(openstack_compute_instance_v2.jenkins-workers-org.*.id, count.index)}"]
  volume_id   = ["${element(openstack_blockstorage_volume_v2.jenkins-workers-org-data.*.id, count.index)}"]
  count       = 2
}

resource "aws_route53_record" "jenkins-workers-org" {
  zone_id = "${var.zone_galaxyproject_eu}"
  name    = "n${count.index}.galaxyproject.eu"
  type    = "A"
  ttl     = "7200"
  records = ["${element(openstack_compute_instance_v2.jenkins-workers-org.*.access_ip_v4, count.index)}"]
  count   = 2
}
