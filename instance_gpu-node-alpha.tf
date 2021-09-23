variable "gpu-node-alpha-dns" {
  default = "gpu-node-alpha.galaxyproject.eu"
}

data "openstack_images_image_v2" "gpu-node-alpha-image" {
  name = "vggp-v40-j238-9b9c0ecd5697-master"
}

resource "openstack_compute_instance_v2" "gpu-node-alpha" {
  name            = "${var.gpu-node-alpha-dns}"
  flavor_name     = "g1.g1c40m110"
  key_pair        = "cloud2"
  security_groups = ["default", "public-ssh"]

  network {
    name = "public"
  }

  block_device {
    uuid                  = "${data.openstack_images_image_v2.gpu-node-alpha-image.id}"
    source_type           = "image"
    volume_size           = 200
    destination_type      = "volume"
    boot_index            = 0
    delete_on_termination = true
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
    package_update: true
    package_upgrade: true
    packages:
    - cuda-11-4
    - nvidia-container-toolkit
  EOF
}

resource "random_id" "gpu-node-alpha-volume_name_unique" {
  byte_length = 8
}

resource "openstack_blockstorage_volume_v2" "gpu-node-alpha-vol" {
  name        = "gpu-node-alpha-data-vol-${random_id.gpu-node-alpha-volume_name_unique.hex}"
  volume_type = "default"
  description = "Data volume for gpu-node-alpha"
  size        = 500
}

resource "openstack_compute_volume_attach_v2" "gpu-node-alpha-internal-va" {
  instance_id = "${openstack_compute_instance_v2.gpu-node-alpha.id}"
  volume_id   = "${openstack_blockstorage_volume_v2.gpu-node-alpha-vol.id}"
}

resource "aws_route53_record" "gpunodealpha" {
  zone_id = "${var.zone_galaxyproject_eu}"
  name    = "${var.gpu-node-alpha-dns}"
  type    = "A"
  ttl     = "600"
  records = ["${openstack_compute_instance_v2.gpu-node-alpha.access_ip_v4}"]
}
