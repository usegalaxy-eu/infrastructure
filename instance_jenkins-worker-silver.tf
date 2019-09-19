variable "workers-silver" {
  default = 1
}

variable "workers-silver-volume-size" {
  default = 50
}

resource "openstack_compute_instance_v2" "jenkins-workers-silver" {
  name            = "worker-${count.index}.silver.build.galaxyproject.eu"
  image_name      = "${var.jenkins_image}"
  flavor_name     = "m1.xlarge"
  key_pair        = "jenkins2"
  security_groups = ["public"]
  count           = "${var.workers-silver}"

  network {
    name = "public"
  }

  user_data = <<-EOF
    #cloud-config
    bootcmd:
        - test -z "$(blkid /dev/vdb)" && mkfs -t ext4 -L jenkins /dev/vdb
        - mkdir -p /data
    mounts:
        - ["/dev/vdb", "/data", auto, "defaults,nofail", "0", "2"]
    runcmd:
        - [ chown, "centos.centos", -R, /data ]
  EOF

}

resource "openstack_blockstorage_volume_v2" "jenkins-workers-silver-volume" {
  name        = "jenkins-workers-silver-volume"
  description = "Data volume for Jenkins worker-${count.index}.silver.build.galaxyproject.eu"
  size        = "${var.workers-silver-volume-size}"
  count       = "${var.workers-silver}"
}

resource "openstack_compute_volume_attach_v2" "jenkins-workers-silver-va" {
  instance_id = "${element(openstack_compute_instance_v2.jenkins-workers-silver.*.id, count.index)}"
  volume_id   = "${element(openstack_blockstorage_volume_v2.jenkins-workers-silver-volume.*.id, count.index)}"
  count       = "${var.workers-silver}"
}

resource "aws_route53_record" "jenkins-workers-silver" {
  zone_id = "${var.zone_galaxyproject_eu}"
  name    = "worker-${count.index}.silver.build.galaxyproject.eu"
  type    = "A"
  ttl     = "7200"
  records = ["${element(openstack_compute_instance_v2.jenkins-workers-silver.*.access_ip_v4, count.index)}"]
  count   = "${var.workers-silver}"
}
