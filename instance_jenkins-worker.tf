resource "openstack_compute_instance_v2" "jenkins-workers" {
  name            = "worker-${count.index}.build.galaxyproject.eu"
  image_name      = "${var.jenkins_image}"
  flavor_name     = "m1.xlarge"
  key_pair        = "build-usegalaxy-eu"
  security_groups = ["public"]
  count           = 2

  network {
    name = "public"
  }
}

resource "openstack_compute_instance_v2" "jenkins-workers-internal" {
  name            = "worker-internal-${count.index}.build.galaxyproject.eu"
  image_name      = "${var.jenkins_image}"
  flavor_name     = "m1.xlarge"
  key_pair        = "build-usegalaxy-eu"
  security_groups = ["public"]
  count           = 1

  network {
    name = "public-extended"
  }
}
