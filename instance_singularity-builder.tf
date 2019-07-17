resource "openstack_compute_instance_v2" "singularity-builder" {
  name            = "singularity-builder"
  image_name      = "${var.centos_image}"
  flavor_name     = "c.c32m240"
  key_pair        = "cloud2"
  security_groups = ["egress", "ufr-ssh", "public-ping", "public-influxdb", "public-web2"]

  network {
    name = "public"
  }
}

resource "openstack_blockstorage_volume_v2" "singularity-builder-data" {
  name        = "singularity-builder"
  description = "Data volume for singularity-builder"
  size        = 1024
}

resource "openstack_compute_volume_attach_v2" "singularity-builder-va" {
  instance_id = "${openstack_compute_instance_v2.singularity-builder.id}"
  volume_id   = "${openstack_blockstorage_volume_v2.singularity-builder-data.id}"
}
