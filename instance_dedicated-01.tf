variable "dedicated-01-dns" {
  default = "dn01.galaxyproject.eu"
}

data "openstack_images_image_v2" "dedicated-01-image" {
  name = "Ubuntu 20.04"
}

resource "openstack_compute_instance_v2" "dedicated-01" {
  name        = "${var.dedicated-01-dns}"
  image_id    = "${data.openstack_images_image_v2.dedicated-01-image.id}"
  flavor_name = "c.c40m110"
  key_pair    = "cloud2"
  security_groups = [
    "default",
    "public-ssh"]

  network {
    name = "public"
  }

  user_data = <<-EOF
    #cloud-config
    package_update: true
    package_upgrade: true
    packages:
     - lvm2
    users:
     - default
    ssh_authorized_keys:
     - "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABAQC8/9GdD96Xfc0MavIJQEuNSIrOlaBSYkH4s5RyGhNnc8Al7x3hC7KXt/mcqyNoI1JTvrXp23aDpTr67e3Dnrp6Me7z8nyY9oIy5WHOgwG2ra1Ga8oi89MVgXPhtxvcYnk8hVfuPDmhWkgwS5ILH/7V/1hEKHcS0H7Q0pJp8EGCBDFWrxNfUWqJJuVcXb11CMnaSJX/VhD+S4g4rG01lMr696+k8eKs9y2sq9JpuUD1TNN16RYu1uVlVz8nhIPbEBsnFeKV+EYKLcSRQnjDTNjWqZHHM9NMWfK3wGvr5pfla158ZdsYQTmQtcchTsEoB+7eAQaER3XsEtuo8yQj4zbL"
  EOF
}

resource "random_id" "dedicated-01-volume_name_unique" {
  byte_length = 8
}

resource "openstack_blockstorage_volume_v2" "dedicated-01-vol" {
  name        = "dedicated-01-data-vol-${random_id.dedicated-01-volume_name_unique.hex}"
  volume_type = "default"
  description = "Data volume for dedicated-01 node"
  size        = 500
}

resource "openstack_compute_volume_attach_v2" "dedicated-01-va" {
  instance_id = "${openstack_compute_instance_v2.dedicated-01.id}"
  volume_id   = "${openstack_blockstorage_volume_v2.dedicated-01-vol.id}"
}
