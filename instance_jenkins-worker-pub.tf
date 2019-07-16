variable "workers" {
  default = 2
}

resource "openstack_compute_instance_v2" "jenkins-workers" {
  name            = "worker-${count.index}.build.galaxyproject.eu"
  image_name      = "${var.jenkins_image}"
  flavor_name     = "m1.xlarge"
  key_pair        = "jenkins2"
  security_groups = ["public"]
  count           = "${var.workers}"

  network {
    name = "public"
  }
}

resource "aws_route53_record" "jenkins-workers" {
  zone_id = "${var.zone_galaxyproject_eu}"
  name    = "worker-${count.index}.build.galaxyproject.eu"
  type    = "A"
  ttl     = "7200"
  records = ["${element(openstack_compute_instance_v2.jenkins-workers.*.access_ip_v4, count.index)}"]
  count   = "${var.workers}"
}
