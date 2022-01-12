variable "student-bnn-dns" {
  default = "student-bnn-vm"
}

data "openstack_images_image_v2" "student-bnn-image" {
  name = "Ubuntu 20.04"
}

resource "openstack_compute_instance_v2" "student-bnn" {
  name        = "${var.student-bnn-dns}"
  image_id    = "${data.openstack_images_image_v2.student-bnn-image.id}"
  flavor_name = "m1.xlarge"
  key_pair    = "cloud2"
  security_groups = [
    "default",
    "public-ssh"]

  network {
    name = "public"
  }

  block_device {
    uuid                  = "${data.openstack_images_image_v2.student-bnn-image.id}"
    source_type           = "image"
    volume_size           = 200
    destination_type      = "volume"
    boot_index            = 0
    delete_on_termination = true
  }

  user_data = <<-EOF
    #cloud-config
    package_update: true
    package_upgrade: true
    users:
     - default
    ssh_authorized_keys:
     - "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABAQC8/9GdD96Xfc0MavIJQEuNSIrOlaBSYkH4s5RyGhNnc8Al7x3hC7KXt/mcqyNoI1JTvrXp23aDpTr67e3Dnrp6Me7z8nyY9oIy5WHOgwG2ra1Ga8oi89MVgXPhtxvcYnk8hVfuPDmhWkgwS5ILH/7V/1hEKHcS0H7Q0pJp8EGCBDFWrxNfUWqJJuVcXb11CMnaSJX/VhD+S4g4rG01lMr696+k8eKs9y2sq9JpuUD1TNN16RYu1uVlVz8nhIPbEBsnFeKV+EYKLcSRQnjDTNjWqZHHM9NMWfK3wGvr5pfla158ZdsYQTmQtcchTsEoB+7eAQaER3XsEtuo8yQj4zbL"
  EOF
}
