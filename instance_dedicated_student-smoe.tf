variable "student-smoe-dns" {
  default = "student-smoe-vm"
}

variable "student-smoe-volume-size" {
  default = 100
}

data "openstack_images_image_v2" "student-smoe-image" {
  name = "Ubuntu 20.04"
}

resource "openstack_compute_instance_v2" "student-smoe" {
  name            = var.student-smoe-dns
  image_id        = data.openstack_images_image_v2.student-smoe-image.id
  flavor_name     = "m1.c8m16_no_qos"
  key_pair        = "cloud2"
  security_groups = ["default", "public-ssh", "public-web2", "public-irods", "public-onedata", "public-onedata2"]

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

resource "openstack_blockstorage_volume_v2" "student-smoe-volume" {
  name        = "student-smoe-volume"
  description = "Data volume for student-smoe instance"
  volume_type = "default"
  size        = var.student-smoe-volume-size
}

resource "openstack_compute_volume_attach_v2" "student-smoe-va" {
  instance_id = openstack_compute_instance_v2.student-smoe.id
  volume_id   = openstack_blockstorage_volume_v2.student-smoe-volume.id
}
