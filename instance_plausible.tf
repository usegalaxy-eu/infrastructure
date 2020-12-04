variable "plausible-dns" {
  default = "plausible.galaxyproject.eu"
}

resource "openstack_compute_instance_v2" "plausible" {
  name            = "${var.plausible-dns}"
  image_name      = "CentOS 8"
  flavor_name     = "m1.large"
  key_pair        = "cloud2"
  security_groups = ["egress", "public-web2", "ufr-ingress", "public-ping"]

  network {
    name = "bioinf"
  }

  user_data = <<-EOF
    #cloud-config
    bootcmd:
        - test -z "$(blkid /dev/vdb)" && mkfs -t ext4 /dev/vdb
        - mkdir -p /data
    mounts:
        - ["/dev/vdb", "/data", auto, "defaults,nofail", "0", "2"]
    runcmd:
        - [ chown, "centos.centos", -R, /data ]
  EOF
}

resource "openstack_blockstorage_volume_v2" "plausible-volume" {
  name        = "plausible-volume"
  description = "Data volume for ${var.plausible-dns}"
  size        = "50"
}

resource "openstack_compute_volume_attach_v2" "plausible-internal-va" {
  instance_id = "${openstack_compute_instance_v2.plausible.id}"
  volume_id   = "${openstack_blockstorage_volume_v2.plausible-volume.id}"
}

resource "aws_route53_record" "plausible" {
  zone_id = "${var.zone_usegalaxy_eu}"
  name    = "${var.plausible-dns}"
  type    = "A"
  ttl     = "600"
  records = ["${openstack_compute_instance_v2.plausible.access_ip_v4}"]
}
