variable "student-smoe2-dns" {
  default = "student-smoe2-vm"
}

data "openstack_images_image_v2" "student-smoe2-image" {
  name = "Ubuntu 20.04"
}

resource "openstack_compute_instance_v2" "student-smoe2" {
  name            = var.student-smoe2-dns
  image_id        = data.openstack_images_image_v2.student-smoe2-image.id
  flavor_name     = "m1.medium"
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
