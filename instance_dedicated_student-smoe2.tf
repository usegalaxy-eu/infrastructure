variable "student-smoe2-dns" {
  default = "student-smoe2-vm"
}

variable "student-smoe2-volume-size" {
  default = 100
}

data "openstack_images_image_v2" "student-smoe2-image" {
  name = "Ubuntu 20.04"
}

resource "openstack_compute_instance_v2" "student-smoe2" {
  name            = var.student-smoe2-dns
  image_id        = data.openstack_images_image_v2.student-smoe2-image.id
  flavor_name     = "m1.c8m16_no_qos"
  key_pair        = "cloud2"
  security_groups = ["default", "public-ssh", "public-web2", "public-irods"]

  network {
    name = "public-extended"
  }

  user_data = <<-EOF
    #cloud-config
    package_update: true
    package_upgrade: true
    users:
     - default
    ssh_authorized_keys:
     - "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIFaDO2gPp78zX4VQahUxklW5hYvvOVO5SH9Lj9Pit+4q"
  EOF
}

resource "openstack_blockstorage_volume_v2" "student-smoe2-volume" {
  name        = "student-smoe2-volume"
  description = "Data volume for student-smoe2 instance"
  volume_type = "default"
  size        = var.student-smoe2-volume-size
}

resource "openstack_compute_volume_attach_v2" "student-smoe2-va" {
  instance_id = openstack_compute_instance_v2.student-smoe2.id
  volume_id   = openstack_blockstorage_volume_v2.student-smoe2-volume.id
}
