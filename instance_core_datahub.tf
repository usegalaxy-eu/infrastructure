variable "datahub-dns" {
  default = "datahub.galaxyproject.eu"
}

data "openstack_images_image_v2" "datahub-image" {
  name = "CentOS Stream 8"
}

resource "openstack_compute_instance_v2" "datahub" {
  name            = var.datahub-dns
  image_id        = data.openstack_images_image_v2.datahub-image.id
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

