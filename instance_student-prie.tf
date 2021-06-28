data "openstack_images_image_v2" "student-prie-image" {
  name = "Ubuntu 20.04"
}

resource "openstack_compute_instance_v2" "student-prie" {
  name            = "student-prie"
  image_id        = "${data.openstack_images_image_v2.student-prie-image.id}"
  flavor_name     = "m1.large"
  key_pair        = "cloud2"
  security_groups = ["default", "public-ssh"]

  network {
    name = "public"
  }
}


