variable "student-sambhav-dns" {
  default = "student-sambhav-vm"
}

variable "student-sambhav-volume-size" {
  default = 200
}

resource "openstack_compute_instance_v2" "student-sambhav-instance" {
  name            = var.student-sambhav-dns
  flavor_name     = "c1.c36m100"
  image_name      = "Ubuntu 20.04"
  key_pair        = "cloud2"
  security_groups = ["default", "public-ssh"]

  network {
    name = "public"
  }

  user_data = <<-EOF
    #cloud-config
    package_update: true
    package_upgrade: true
    users:
     - default
    ssh_authorized_keys:
     - "AAAAC3NzaC1lZDI1NTE5AAAAIK4K5z6HSF0w49yAw/DwPrdZ1mDuE9x0jrc3I2wJN1Ci"
    bootcmd:
        - test -z "$(blkid /dev/vdb)" && mkfs -t xfs /dev/vdb
        - mkdir -p /scratch
    mounts:
        - ["/dev/vdb", "/scratch", auto, "defaults,nofail", "0", "2"]
    runcmd:
        - [ chown, "ubuntu.ubuntu", -R, /scratch ]
        - [ chmod, "a+rw", /scratch ]
  EOF
}

resource "openstack_blockstorage_volume_v2" "student-sambhav-volume" {
  name        = "student-sambhav-volume"
  description = "Data volume for student-sambhav instance"
  volume_type = "default"
  size        = var.student-sambhav-volume-size
}

resource "openstack_compute_volume_attach_v2" "student-sambhav-va" {
  instance_id = openstack_compute_instance_v2.student-sambhav-instance.id
  volume_id   = openstack_blockstorage_volume_v2.student-sambhav-volume.id
}
