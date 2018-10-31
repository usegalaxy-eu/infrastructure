resource "openstack_compute_instance_v2" "training-beta" {
  name            = "vgcnbwc-training-beta-${count.index}"
  image_name      = "vggp-v31-j95-9c1a332fb4d7-master"
  flavor_name     = "c.c10m55"
  key_pair        = "cloud2"
  security_groups = ["public"]
  count           = 1

  user_data = "${file("conf/node-new.yml")}"

  network {
    name = "bioinf"
  }
}
