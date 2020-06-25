variable "workers-internal" {
  default = 1
}

variable "workers-internal-volume-size" {
  default = 100
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

resource "openstack_blockstorage_volume_v2" "jenkins-workers-internal-volume" {
  name        = "jenkins-workers-${count.index}-internal-volume"
  description = "Data volume for Jenkins worker-${count.index}.internal.build.galaxyproject.eu"
  size        = "${var.workers-internal-volume-size}"
  count       = "${var.workers-internal}"
}

resource "openstack_compute_volume_attach_v2" "jenkins-workers-internal-va" {
  instance_id = "${element(openstack_compute_instance_v2.jenkins-workers-internal.*.id, count.index)}"
  volume_id   = "${element(openstack_blockstorage_volume_v2.jenkins-workers-internal-volume.*.id, count.index)}"
  count       = "${var.workers-internal}"
}

resource "aws_route53_record" "jenkins-workers-internal" {
  zone_id = "${var.zone_galaxyproject_eu}"
  name    = "worker-internal-${count.index}.build.galaxyproject.eu"
  type    = "A"
  ttl     = "7200"
  records = ["${element(openstack_compute_instance_v2.jenkins-workers-internal.*.access_ip_v4, count.index)}"]
  count   = "${var.workers-internal}"
}
