resource "openstack_compute_instance_v2" "ftp" {
  name        = "ftp.usegalaxy.eu"
  image_name  = "${var.centos_image_new}"
  flavor_name = "m1.small"
  key_pair    = "cloud2"

  # TODO: tighten up secgroups
  security_groups = ["egress", "public"]

  network {
    name = "bioinf"
  }
}
