variable "workers-gold" {
  default = 1
}

resource "openstack_compute_instance_v2" "jenkins-workers-gold" {
  name            = "worker-${count.index}.gold.build.galaxyproject.eu"
  image_name      = "${var.jenkins_image}"
  flavor_name     = "m1.xlarge"
  key_pair        = "jenkins2"
  security_groups = ["public"]
  count           = "${var.workers-gold}"

  network {
    name = "public"
  }

  user_data = <<-EOF
    #cloud-config
    bootcmd:
        - mkdir -p /data
    runcmd:
        - [ chown, "centos.centos", -R, /data ]
  EOF
}

resource "aws_route53_record" "jenkins-workers-gold" {
  zone_id = "${var.zone_galaxyproject_eu}"
  name    = "worker-${count.index}.gold.build.galaxyproject.eu"
  type    = "A"
  ttl     = "7200"
  records = ["${element(openstack_compute_instance_v2.jenkins-workers-gold.*.access_ip_v4, count.index)}"]
  count   = "${var.workers-gold}"
}
