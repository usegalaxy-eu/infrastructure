resource "openstack_compute_instance_v2" "test-a" {
  name            = "test-a.usegalaxy.eu"
  image_name      = "${var.centos_image}"
  flavor_name     = "m1.large"
  key_pair        = "cloud2"
  security_groups = "${var.sg_webservice-pubssh}"

  network {
    name = "public"
  }
}

resource "openstack_compute_instance_v2" "test-b" {
  name            = "test-b.usegalaxy.eu"
  image_name      = "${var.centos_image}"
  flavor_name     = "m1.large"
  key_pair        = "cloud2"
  security_groups = "${var.sg_webservice-pubssh}"

  network {
    name = "public"
  }
}
