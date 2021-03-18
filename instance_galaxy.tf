variable "test-galaxy_image" {
  default = "CentOS 8"
}

variable "test-galaxy-volume-size" {
  default = 100
}

resource "openstack_compute_instance_v2" "test-galaxy" {
  name            = "test.internal.usegalaxy.eu"
  image_name      = "${var.test-galaxy_image}"
  flavor_name     = "m1.large"
  key_pair        = "cloud2"
  security_groups = ["egress", "public-web2", "ufr-ingress", "public-ping"]

  network {
    name = "bioinf"
  }

  user_data = <<-EOF
    #cloud-config
    bootcmd:
        - test -z "$(blkid /dev/vdb)" && mkfs -t ext4 /dev/vdb && mkdir -p /opt/galaxy
        - test -z "$(blkid /dev/vdc)" && mkfs -t ext4 /dev/vdc && mkdir -p /var/lib/cvmfs && chown -R cvmfs.cvmfs /var/lib/cvmfs
    mounts:
        - ["/dev/vdb", "/opt/galaxy", auto, "defaults,nofail", "0", "2"]
        - ["/dev/vdc", "/var/lib/cvmfs", auto, "defaults,nofail", "0", "2"]
  EOF
}

resource "openstack_blockstorage_volume_v2" "test-galaxy-volume" {
  name        = "test-galaxy-volume"
  description = "Data volume for test.usegalaxy.eu"
  volume_type = "netapp"
  size        = "${var.test-galaxy-volume-size}"
}

resource "openstack_compute_volume_attach_v2" "test-galaxy-internal-va" {
  instance_id = "${openstack_compute_instance_v2.test-galaxy.id}"
  volume_id   = "${openstack_blockstorage_volume_v2.test-galaxy-volume.id}"
}

resource "openstack_blockstorage_volume_v2" "test-galaxy-cvmfs-cache-volume" {
  name        = "test-galaxy-cvmfs-cache-volume"
  description = "CVMFS cache volume for test.usegalaxy.eu"
  volume_type = "netapp"
  size        = "10"
}

resource "openstack_compute_volume_attach_v2" "test-galaxy-internal-va2" {
  instance_id = "${openstack_compute_instance_v2.test-galaxy.id}"
  volume_id   = "${openstack_blockstorage_volume_v2.test-galaxy-cvmfs-cache-volume.id}"
}

resource "aws_route53_record" "test-galaxy" {
  zone_id = "${var.zone_usegalaxy_eu}"
  name    = "test.internal.usegalaxy.eu"
  type    = "A"
  ttl     = "600"
  records = ["${openstack_compute_instance_v2.test-galaxy.access_ip_v4}"]
}
