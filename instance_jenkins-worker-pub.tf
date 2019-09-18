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

  user_data = <<-EOF
    #cloud-config
    disk_setup:
        /dev/vdb:
        table_type: mbr
        layout: True
        overwrite: True
    fs_setup:
        - device: /dev/vdb
          partition: 1
          filesystem: ext4
    mounts:
        - ["/dev/vdb", "/data", auto, "defaults,nofail"]
    runcmd:
        - [ chown, "centos':'centos", -R, /data ]
  EOF
}

resource "openstack_blockstorage_volume_v2" "jenkins-workers-volume" {
  name        = "jenkins-workers-volume"
  description = "Data volume for Jenkins worker-${count.index}.build.galaxyproject.eu"
  size        = 50
  count       = "${var.workers}"
}

resource "openstack_compute_volume_attach_v2" "jenkins-workers-va" {
  instance_id = "${element(openstack_compute_instance_v2.jenkins-workers.*.id, count.index)}"
  volume_id   = "${element(openstack_blockstorage_volume_v2.jenkins-workers-volume.*.id, count.index)}"
  count       = "${var.workers}"
}

resource "aws_route53_record" "jenkins-workers" {
  zone_id = "${var.zone_galaxyproject_eu}"
  name    = "worker-${count.index}.build.galaxyproject.eu"
  type    = "A"
  ttl     = "7200"
  records = ["${element(openstack_compute_instance_v2.jenkins-workers.*.access_ip_v4, count.index)}"]
  count   = "${var.workers}"
}
