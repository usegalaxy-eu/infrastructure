variable "upload-dns" {
  default = "upload.galaxyproject.eu"
}

data "openstack_images_image_v2" "upload-image" {
  name = "CentOS Stream 8"
}

resource "openstack_compute_instance_v2" "upload" {
  name            = var.upload-dns
  image_id        = data.openstack_images_image_v2.upload-image.id
  flavor_name     = "m1.small"
  key_pair        = "cloud2"
  security_groups = ["default", "public-ssh", "public-web2", "ufr-ingress"]

  network {
    name = "public-extended"
  }

  user_data = <<-EOF
    #cloud-config
    package_update: true
    package_upgrade: true
  EOF
}
