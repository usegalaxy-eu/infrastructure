resource "openstack_compute_instance_v2" "training-bioinfbrad2018_1" {
  name            = "vgcnbwc-training-bioinfbrad2018_1-${count.index}"
  image_name      = "${var.vgcn_image}"
  flavor_name     = "c.c10m55"
  key_pair        = "cloud2"
  security_groups = ["public"]
  count           = 1

  user_data = "${file("conf/node.yml")}"

  network {
    name = "bioinf"
  }
}
