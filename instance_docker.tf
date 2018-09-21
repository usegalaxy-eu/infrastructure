resource "openstack_compute_instance_v2" "docker-host" {
  name            = "docker-host.usegalaxy.eu"
  image_name      = "${var.centos_image}"
  flavor_name     = "m1.xxlarge"
  key_pair        = "cloud2"
  security_groups = "${var.sg_webservice}"

  network {
    name = "public"
  }
}
