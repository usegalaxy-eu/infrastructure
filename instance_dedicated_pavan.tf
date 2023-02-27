data "openstack_images_image_v2" "pavan-image" {
  name = "Ubuntu 20.04"
}

resource "openstack_compute_instance_v2" "pavan" {
  name            = "Pavan dedicated VM"
  image_id        = data.openstack_images_image_v2.pavan-image.id
  flavor_name     = "c1.c36m225"
  key_pair        = "cloud2"
  security_groups = ["default"]

  network {
    name = "public"
  }

  user_data = <<-EOF
    #cloud-config
    bootcmd:
        - test -z "$(blkid /dev/vdb)" && mkfs -t ext4 /dev/vdb
        - mkdir -p /scratch
    mounts:
        - ["/dev/vdb", "/scratch", auto, "defaults,nofail", "0", "2"]
    runcmd:
        - [ chown, "ubuntu.ubuntu", -R, /scratch ]
    package_update: true
    package_upgrade: true
    users:
     - default
    ssh_authorized_keys:
     - "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABAQC8/9GdD96Xfc0MavIJQEuNSIrOlaBSYkH4s5RyGhNnc8Al7x3hC7KXt/mcqyNoI1JTvrXp23aDpTr67e3Dnrp6Me7z8nyY9oIy5WHOgwG2ra1Ga8oi89MVgXPhtxvcYnk8hVfuPDmhWkgwS5ILH/7V/1hEKHcS0H7Q0pJp8EGCBDFWrxNfUWqJJuVcXb11CMnaSJX/VhD+S4g4rG01lMr696+k8eKs9y2sq9JpuUD1TNN16RYu1uVlVz8nhIPbEBsnFeKV+EYKLcSRQnjDTNjWqZHHM9NMWfK3wGvr5pfla158ZdsYQTmQtcchTsEoB+7eAQaER3XsEtuo8yQj4zbL"
  EOF
}


resource "random_id" "pavan-volume_name_unique" {
  byte_length = 8
}

resource "openstack_blockstorage_volume_v2" "pavan-vol" {
  name        = "pavan-data-vol-${random_id.pavan-volume_name_unique.hex}"
  volume_type = "default"
  description = "Data volume for pavan VM"
  size        = 500
}

resource "openstack_compute_volume_attach_v2" "pavan-va" {
  instance_id = openstack_compute_instance_v2.pavan.id
  volume_id   = openstack_blockstorage_volume_v2.pavan-vol.id
}
