data "openstack_images_image_v2" "pavan_pula-image" {
  name = "Ubuntu 20.04"
}

resource "openstack_compute_instance_v2" "pavan_pula" {
  name            = "Pavan_Pula dedicated VM"
  flavor_name     = "m1.large"
  key_pair        = "cloud2"
  security_groups = ["default", "public-ssh", "public-web2"]

  network {
    name = "public"
  }

  block_device {
    uuid                  = data.openstack_images_image_v2.pavan_pula-image.id
    source_type           = "image"
    volume_size           = 500
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
     - "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABgQC3MnKZoBH/1KNDGc+yLjhNUmo4cqZl6j0PUPI0/YyU0vbYNybKJjU/YjKaHoJjR1G5FzzciLBjwWljT7QqSpAvYb48ibFCl3vNZEvVnP1imzaEiGrLxTXAAWTvfosWxRkkudOHPhSPTjaQe5DWub5AMkB2gN+OydnFoi3HphiQtUmNKmywbC4x7KN+siil1xEmJYtxVekVVKcW8tg9d2R4icGsMryWiTerGvEO4YHtANjRV9VU5VC6f4aOH6MbVBH/BITAtu38KLR0DiJD+FGPJH2QQE/xcLWBXyJp5abZjieiT+oC6Uq6r9SneycBiMeBesUG5oSvHg4600KK8NHNPSLNhKsT/qJw1NGNcjMmjq8XQeCuZ/CWPmzJkwGSh9wJqLQ6g7BWMZsmvlobmT+P6g/QVHHuR/uy4UqpZNTOh4dcWZmu+PYQFL64DIyyrwxX7c66rNkK6lxXCrt0QfS79B0XB5rn8u/dKGHXgRNnDfXCvWA/pd3XLiJJwLN+a7k= Pulaparthi@PavanPV"
  EOF
}

