data "openstack_images_image_v2" "student-abdus-image" {
  name = "Ubuntu 20.04"
}

resource "openstack_compute_instance_v2" "student-abdus" {
  name            = "student-abdus"
  image_id        = "${data.openstack_images_image_v2.student-abdus-image.id}"
  flavor_name     = "m1.large"
  key_pair        = "cloud2"
  security_groups = ["default", "public-ssh"]

  network {
    name = "public"
  }

  block_device {
    uuid                  = "${data.openstack_images_image_v2.student-abdus-image.id}"
    source_type           = "image"
    destination_type      = "local"
    boot_index            = 0
    delete_on_termination = true
  }

  block_device {
    uuid                  = "${openstack_blockstorage_volume_v2.student-abdus-vol.id}"
    source_type           = "volume"
    destination_type      = "volume"
    boot_index            = -1
    delete_on_termination = true
  }

  user_data = <<-EOF
    #cloud-config
    disk_setup:
      /dev/vdb:
        table_type: mbr
        layout: True
        overwrite: True
    fs_setup:
     - label: None
       filesystem: ext4
       device: /dev/vdb
       partition: none
    mounts:
     - [ /dev/vdb, /scratch, ext4, "defaults", "0", "2" ]
    runcmd:
     - mkdir -p /scratch/users
     - chmod 0777 /scratch/users
    package_update: true
    package_upgrade: true
    users:
     - default
     - name: user
       shell: /bin/bash
       lock_passwd: true
       ssh_authorized_keys:
         - "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAACAQDAcOUqdEnLKbscPifpi43x5SDlZHze/HM6LGhWHniWegfvfjZvLz9yJDdgK33nx1u03nlCq33g90GFj5eUch/g5ZlwUUi9q0ebncEK4fQrnDvFz98NSfKgb+BYsXaY3IQrP6jE5qPGZeyyRA7gaS1Q2yZx9M36g4tBJ8Fo08U8o0XCxFF0wDEdoO+9bo+1+SBb2oJ1S5C/1DTw3PXwLFJmALM/Lvy/d4ckIeE+y0tV8GZ3w/wjIvZ4n6f0iTk1QGSqC/R21fpnLinLDUe9+XLQ08MrooDCq0JwzmbIwPiYgw68TfsnJmLncnAIEaiajr9Mu6tBM/XTEIO2HaUHoDY232FH+uh9FAmLc1/8RMi6QtD2UL4Zq2HOGYh2ZjCTZhXRCHDHY+LmepmGaZHPyYdPlYb14hiJiRIFsTPyMPFw/YuayHQF9YJRyESiHc7xsuk2D3dtghHrA0inWmVC3mSNMwV5d9lwI8vg3SRVFyWPsdiJy0a6LGLyjuZWTyZggc21FPJTxbOr48qPN7UGWNSgGMkhnNCuBDv18QvAGHZrHaCwge6IfxfQ5kW+8ANG3raBPkHt/PpG7QQ0IUi2vvX5xK9tS9cE5ZcvPawHxtacpdj+QgpRIsaqiH1YP+H/ZqBu4e4OpOFqR5Nk7eGsIREKb9q3nuo1COvK7gBMKIDJoQ=="
  EOF
}

resource "random_id" "student-abdus-volume_name_unique" {
  byte_length = 8
}

resource "openstack_blockstorage_volume_v2" "student-abdus-vol" {
  name = "student-abdus-scratch-vol-${random_id.student-abdus-volume_name_unique.hex}"
  size = 100
}
