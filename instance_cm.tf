variable "cm_image" {
  default = "CentOS 8"
}

resource "openstack_compute_instance_v2" "vgcn-cm" {
  name            = "central-manager.galaxyproject.eu"
  image_name      = "${var.cm_image}"
  flavor_name     = "m1.small"
  key_pair        = "cloud2"
  security_groups = ["public"]

  network {
    name = "bioinf"
  }
}
