variable "jump-dns" {
  default = "jump.galaxyproject.eu"
}

data "openstack_images_image_v2" "jump-image" {
  name = "CentOS Stream 8"
}

resource "openstack_compute_instance_v2" "jump" {
  name            = var.jump-dns
  image_id        = data.openstack_images_image_v2.jump-image.id
  flavor_name     = "m1.small"
  key_pair        = "cloud2"
  security_groups = ["default", "public-ssh"]

  network {
    name = "public-extended"
  }

  user_data = <<-EOF
    #cloud-config
    package_update: true
    package_upgrade: true
  EOF
}

