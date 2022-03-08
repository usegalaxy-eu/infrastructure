variable "workers-gold" {
  default = 1
}

variable "workers-gold-volume-size" {
  default = 200
}

resource "openstack_compute_instance_v2" "jenkins-workers-gold" {
  name            = "worker-${count.index}.gold.build.galaxyproject.eu"
  image_name      = var.jenkins_image
  flavor_name     = "m1.xlarge"
  key_pair        = "jenkins2"
  security_groups = ["default"]
  count           = var.workers-gold

  network {
    name = "public-extended"
  }

  user_data = <<-EOF
    #cloud-config
    bootcmd:
        - test -z "$(blkid /dev/vdb)" && mkfs -t ext4 -L jenkins /dev/vdb
        - mkdir -p /data
    mounts:
        - ["/dev/vdb", "/scratch", auto, "defaults,nofail", "0", "2"]
    runcmd:
        - [ chown, "centos.centos", -R, /scratch ]
  EOF
}

resource "openstack_blockstorage_volume_v2" "jenkins-workers-gold-volume" {
  name        = "jenkins-workers-${count.index}-gold-volume"
  description = "Data volume for Jenkins worker-${count.index}.gold.build.galaxyproject.eu"
  volume_type = "default"
  size        = var.workers-gold-volume-size
  count       = var.workers-gold
}

resource "openstack_compute_volume_attach_v2" "jenkins-workers-gold-va" {
  instance_id = element(openstack_compute_instance_v2.jenkins-workers-gold.*.id, count.index)
  volume_id   = element(openstack_blockstorage_volume_v2.jenkins-workers-gold-volume.*.id, count.index)
  count       = var.workers-gold
}

resource "aws_route53_record" "jenkins-workers-gold" {
  allow_overwrite = true
  zone_id         = var.zone_galaxyproject_eu
  name            = "worker-${count.index}.gold.build.galaxyproject.eu"
  type            = "A"
  ttl             = "7200"
  records         = ["${element(openstack_compute_instance_v2.jenkins-workers-gold.*.access_ip_v4, count.index)}"]
  count           = var.workers-gold
}
