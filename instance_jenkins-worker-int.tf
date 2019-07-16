variable "workers-internal" {
  default = 1
}

resource "openstack_compute_instance_v2" "jenkins-workers-internal" {
  name            = "worker-internal-${count.index}.build.galaxyproject.eu"
  image_name      = "${var.jenkins_image}"
  flavor_name     = "m1.xlarge"
  key_pair        = "jenkins2"
  security_groups = ["public"]
  count           = "${var.workers-internal}"

  network {
    name = "public-extended"
  }
}

resource "aws_route53_record" "jenkins-workers-internal" {
  zone_id = "${var.zone_galaxyproject_eu}"
  name    = "worker-internal-${count.index}.build.galaxyproject.eu"
  type    = "A"
  ttl     = "7200"
  records = ["${element(openstack_compute_instance_v2.jenkins-workers-internal.*.access_ip_v4, count.index)}"]
  count   = "${var.workers-internal}"
}
