data "openstack_images_image_v2" "gpu-node-alpha-image" {
  name = "vggp-v40-j238-9b9c0ecd5697-master"
}

resource "openstack_compute_instance_v2" "gpu-node-alpha" {
  name            = "gpu-node-alpha"
  image_id        = "${data.openstack_images_image_v2.gpu-node-alpha-image.id}"
  flavor_name     = "g1.gput4_g1c8m20"
  key_pair        = "cloud2"
  security_groups = ["default", "public-ssh"]

  network {
    name = "public"
  }

  block_device {
    uuid                  = "${data.openstack_images_image_v2.gpu-node-alpha-image.id}"
    source_type           = "image"
    volume_size           = 200
    destination_type      = "local"
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
    users:
     - name: centos
       ssh_authorized_keys:
         - "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABAQCisQ2VSqWfffO9BPfbhL/EycG7EBbSGD4dm7NFEn6sW4WWwvMFdn/YsOK09VdpGA1ryh6xnYOXW+fVx1u0r/ql4tyKlpq5bCwzHiLLkcvIkoSVs5tjrmHwnASBcr1SUNbIHGUFEEIiYD/GjfNslflc2NcMzWtVrExQdCcwFcKsyElMmEG3HNz0uwp91wfArqx8YTRWs5iDXkhjeu0jJsnKQkjjLQDHXmUR5pNZcmYMWJcZhZ4X5w5U1scm2WM/SWSoEjkwP6rZQxsfWD7h5L3V0Ms1nWsoLmIJhVPvLv3o6SKWMoHz62uXeOp9NavOg4pd1fMCak4jMYCHT0TNeU2f"
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
