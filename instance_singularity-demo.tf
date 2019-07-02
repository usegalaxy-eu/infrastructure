resource "openstack_compute_keypair_v2" "cloud2" {
  name       = "mike"
  public_key = "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABAQDuz0HOGjW8WOY61tUao+0ZlVFRoJDBfn7tKLBQQMYwZwCWsHguZ5xXsKVzF0gWVlW80BEU4lkA7IrxUzA+fPgQHLJWZnu1X1ImLtcqNi8qF3OOndLPn0W3iBrpBL4K2R6F8xB9sh9ACxece0ABwvT8LGzmsv6B1m12Pq+7EcJBVrSvXmt7DUKP7xeM++jRtmnNzz5BoRLA54ZW2cyDjCwX4S2LUfza5iXc3GSUZPlkcTNUYxALbevpEZ7e+wny6iGKC2ubJVgwA6rDBaghyYPWeREbL85Q4H87nqmViex1jU1SfiSjGclj+yafZ7oesPFln36lEDMezF0m6ldfjaDF mike@mike7"
}


resource "openstack_compute_instance_v2" "gcc-demo" {
  name            = "${var.count}-singularity-demo.gcc.galaxyproject.eu"
  image_name      = "Ubuntu 18.04"
  flavor_name     = "m1.large"
  key_pair        = "mike"
  count = 2
  security_groups = ["public"]

  network {
    name = "public"
  }
}

resource "openstack_blockstorage_volume_v2" "singularity-demo-data" {
  name        = "singularity-${var.count}"
  description = "Data volume for ${var.count}-singularity"
  size        = 50
  count = 2
}

resource "openstack_compute_volume_attach_v2" "singularity-va" {
  count = 2
  volume_id = "${element(openstack_blockstorage_volume_v2.singularity-demo-data.*.id, count.index)}"
  instance_id = "${element(openstack_compute_instance_v2.gcc-demo.*.id, count.index)}"
}

