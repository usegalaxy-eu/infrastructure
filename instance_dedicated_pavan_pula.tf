data "openstack_images_image_v2" "pavan_pula-image" {
  name = "Ubuntu 20.04"
}

resource "openstack_compute_instance_v2" "pavan_pula" {
  name            = "Pavan_Pula dedicated VM"
  image_id        = data.openstack_images_image_v2.pavan_pula-image.id
  flavor_name     = "m1.large"
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
     - "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABgQC3MnKZoBH/1KNDGc+yLjhNUmo4cqZl6j0PUPI0/YyU0vbYNybKJjU/YjKaHoJjR1G5FzzciLBjwWljT7QqSpAvYb48ibFCl3vNZEvVnP1imzaEiGrLxTXAAWTvfosWxRkkudOHPhSPTjaQe5DWub5AMkB2gN+OydnFoi3HphiQtUmNKmywbC4x7KN+siil1xEmJYtxVekVVKcW8tg9d2R4icGsMryWiTerGvEO4YHtANjRV9VU5VC6f4aOH6MbVBH/BITAtu38KLR0DiJD+FGPJH2QQE/xcLWBXyJp5abZjieiT+oC6Uq6r9SneycBiMeBesUG5oSvHg4600KK8NHNPSLNhKsT/qJw1NGNcjMmjq8XQeCuZ/CWPmzJkwGSh9wJqLQ6g7BWMZsmvlobmT+P6g/QVHHuR/uy4UqpZNTOh4dcWZmu+PYQFL64DIyyrwxX7c66rNkK6lxXCrt0QfS79B0XB5rn8u/dKGHXgRNnDfXCvWA/pd3XLiJJwLN+a7k= Pulaparthi@PavanPV"
  EOF
}


resource "random_id" "pavan_pula-volume_name_unique" {
  byte_length = 8
}

resource "openstack_blockstorage_volume_v2" "pavan_pula-vol" {
  name        = "pavan_pula-data-vol-${random_id.pavan_pula-volume_name_unique.hex}"
  volume_type = "default"
  description = "Data volume for pavan_pula VM"
  size        = 500
}

resource "openstack_compute_volume_attach_v2" "pavan_pula-va" {
  instance_id = openstack_compute_instance_v2.pavan_pula.id
  volume_id   = openstack_blockstorage_volume_v2.pavan_pula-vol.id
}
