data "openstack_images_image_v2" "berenice-image" {
  name = "Ubuntu 20.04"
}

resource "openstack_compute_instance_v2" "berenice" {
  name            = "Berenice dedicated VM"
  image_id        = data.openstack_images_image_v2.berenice-image.id
  flavor_name     = "m1.xxlarge"
  key_pair        = "cloud2"
  security_groups = ["default"]

  network {
    name = "public"
  }

  user_data = <<-EOF
    #cloud-config
    bootcmd:
        - test -z "$(blkid /dev/vdb)" && mkfs -t ext4 /dev/vdb
        - mkdir -p /scratch
    mounts:
        - ["/dev/vdb", "/scratch", auto, "defaults,nofail", "0", "2"]
    runcmd:
        - [ chown, "ubuntu.ubuntu", -R, /scratch ]
    package_update: true
    package_upgrade: true
    users:
     - default
    ssh_authorized_keys:
     - "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIEaIt+ICcS/EStzk07D+5Xrx9AdVQo7rSkI5NqyetTPX"
  EOF
}


resource "random_id" "berenice-volume_name_unique" {
  byte_length = 8
}

resource "openstack_blockstorage_volume_v2" "berenice-vol" {
  name        = "berenice-data-vol-${random_id.berenice-volume_name_unique.hex}"
  volume_type = "default"
  description = "Data volume for Berenice VM"
  size        = 1000
}

resource "openstack_compute_volume_attach_v2" "berenice-va" {
  instance_id = openstack_compute_instance_v2.berenice.id
  volume_id   = openstack_blockstorage_volume_v2.berenice-vol.id
}
