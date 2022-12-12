data "openstack_images_image_v2" "dev-image" {
  name = "Ubuntu 20.04"
}

resource "openstack_compute_instance_v2" "dev" {
  name            = "Dedicated development VM"
  flavor_name     = "m1.xlarge"
  key_pair        = "cloud2"
  security_groups = ["default", "public-ssh", "public-web2"]

  network {
    name = "public"
  }

  block_device {
    uuid                  = data.openstack_images_image_v2.dev-image.id
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
     - "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABgQDL73+WfMW9nom0BtLfPOiDPh9z/t0ZcISLXgW1rUCZe3uXD1QluFJXZeFdBW5Gs8+WaBfBYZyEXrxsPH9CcEIHzNvvdYqh2YDwnEWTbpBahSXSJFOUHU96iRNVq+RpHZMQp70Ib/E0tLeS0sCP1OPlI4SXk7MUwWWAaRB/LCSNsZUqyGNtMlgNwFcefVydwDMEnB1WQeyOAQXOjw7MVlpKEv4ODcHznqzOlqm+LYoYzq5CLkRD8SL1esHUCbrDdZTYu2aO07rkjlRthqZc/xIN89yudn7cDH5ip1bu7N6bzEly0Q/PLLMYp7Aow2vA3Gntjg5M2AL97HUu2Usaj5EW1IGP4sGdH/FY/Nd7HVwpySuHcTQTyrC6+O1z0kXyeF/lWovJa451YcUj4Zh4rsFLtn75T+uwa14jqneSOdnvtP0zMQXhpXxHeEYmpWUUpet3R5B9qjyEnMI4PsxTxw4Qj+KF0C8JwnsHV3MnP7pOBC3+nj5+88th7zwWMziUeMk= alireza@alireza-aluf"
  EOF
}

