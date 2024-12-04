# 26.04.2024: Disabled as not needed anymore
variable "workers-bronze" {
  default = 1
}

variable "workers-bronze-volume-size" {
  default = 200
}

resource "openstack_compute_instance_v2" "jenkins-workers-bronze" {
  name            = "worker-${count.index}.bronze.build.galaxyproject.eu"
  image_name      = var.jenkins_image
  flavor_name     = "m1.xlarge"
  key_pair        = "jenkins2"
  security_groups = ["default"]
  count           = var.workers-bronze

  network {
    name = "bioinf"
  }

  user_data = <<-EOF
    #cloud-config
    bootcmd:
        - test -z "$(blkid /dev/vdb)" && mkfs -t ext4 -L jenkins /dev/vdb
        - mkdir -p /scratch
    mounts:
        - ["/dev/vdb", "/scratch", auto, "defaults,nofail", "0", "2"]
    runcmd:
        - [ chown, "centos.centos", -R, /scratch ]
  EOF
}

resource "openstack_blockstorage_volume_v3" "jenkins-workers-bronze-volume" {
  name        = "jenkins-workers-bronze-volume"
  description = "Data volume for Jenkins worker-${count.index}.bronze.build.galaxyproject.eu"
  volume_type = "default"
  size        = var.workers-bronze-volume-size
  count       = var.workers-bronze
}

resource "openstack_compute_volume_attach_v2" "jenkins-workers-bronze-va" {
  instance_id = element(openstack_compute_instance_v2.jenkins-workers-bronze.*.id, count.index)
  volume_id   = element(openstack_blockstorage_volume_v2.jenkins-workers-bronze-volume.*.id, count.index)
  count       = var.workers-bronze
}

resource "aws_route53_record" "jenkins-workers-bronze" {
  allow_overwrite = true
  zone_id         = var.zone_galaxyproject_eu
  name            = "worker-${count.index}.bronze.build.galaxyproject.eu"
  type            = "A"
  ttl             = "7200"
  records         = ["${element(openstack_compute_instance_v2.jenkins-workers-bronze.*.access_ip_v4, count.index)}"]
  count           = var.workers-bronze
}
