variable "gpu_node_beta_dns" {
  default = "gpu-node-beta.galaxyproject.eu"
}

resource "aws_route53_record" "gpunodebeta" {
  zone_id = "${var.zone_galaxyproject_eu}"
  name    = "${var.gpu_node_beta_dns}"
  type    = "A"
  ttl     = "600"
  records = ["${openstack_compute_instance_v2.gpu-node-beta.access_ip_v4}"]
}

data "openstack_images_image_v2" "gpu_node_beta_image" {
  name = "vggp-v40-j238-9b9c0ecd5697-master"
}

resource "openstack_compute_instance_v2" "gpu_node_beta" {
  name            = "${var.gpu_node_beta_dns}"
  image_id        = "${data.openstack_images_image_v2.gpu_node_beta_image.id}"
  flavor_name     = "g1.g1c40m110"
  key_pair        = "cloud2"
  security_groups = ["default", "public-ssh"]

  network {
    name = "public-extended"
  }

  block_device {
    uuid                  = "${data.openstack_images_image_v2.gpu_node_beta-image.id}"
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

resource "openstack_blockstorage_volume_v2" "gpu_node_beta_vol" {
  name        = "gpu_node_beta_data_vol"
  volume_type = "default"
  description = "Data volume for gpu-node-beta"
  size        = 500
}

resource "openstack_compute_volume_attach_v2" "gpunodebeta-internal-va" {
  instance_id = "${openstack_compute_instance_v2.gpu_node_beta.id}"
  volume_id   = "${openstack_blockstorage_volume_v2.gpu_node_beta_vol.id}"
}

