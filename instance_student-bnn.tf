variable "student-bnn-dns" {
  default = "student-bnn-vm"
}

data "openstack_images_image_v2" "student-bnn-image" {
  name = "Ubuntu 20.04"
}

resource "openstack_compute_instance_v2" "student-bnn" {
  name        = "${var.student-bnn-dns}"
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
     - "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABgQCpsQe36ynq2Pi/HJkv1DvO+j/0vAEvTJE20e4C9O0fyy+1TcUC99mFedaPnbvMRzHh/XIGxsQcD0XrJSHT7fiT5pww88qkydtMySi24jzW/49IBhFsNqbvPlXOdYIVrXtlCbTBqmz4PHoe5mJlo7BjIeWAG2uhaZ/8ZwtbmGmrfj0MuA9yqCSzRbTJ/JesRY5/HIez92aspdHi/z8PUKgHK0hTLD7z2pkrH0YQGOv7STxI8u/ghFXUZ6y1CVjJj3+E/3pulo1Pk1tFLplSsJIyYw11RMu9jmXYTEMNAwdPOefABC+dx31rCklRGNT4DZsLjm1/rfWw2LlQsVQi3Hw19R8F8uhqirGtp8q0GkqgK+OIY4O04HQiMDofe+BDGOe67/KsLn41lHQwSCG3KR7oeggCf7Gr9E55NtzlWmj0Bovr6i1p86r3NBqMzT5guHYY1eZ3+uUTAO/9Q9TfqqbdaSypuCTJlnoOAtWZ3O/PyTLTPzP1sda1kzrwraNPSFU= benno@benno-uni"
  EOF
}
