resource "openstack_compute_instance_v2" "nfs-server" {
  name            = "job-working-dir.internal.galaxyproject.eu"
  image_name      = "generic-centos7-v31-j18-2deef7cb2572-master"
  flavor_name     = "test_qos_free"
  key_pair        = "cloud2"
  security_groups = ["public"]

  network {
    name = "bioinf"
  }
}

resource "openstack_blockstorage_volume_v2" "nfs-server" {
  name        = "job-working-dir"
  description = "Data volume for job-working-dir"
  size        = "${1024 * 20}"
  volume_type = "qos_free"
}

resource "openstack_compute_volume_attach_v2" "nfs-data-va" {
  instance_id = "${openstack_compute_instance_v2.nfs-server.id}"
  volume_id   = "${openstack_blockstorage_volume_v2.nfs-server.id}"
}
