resource "openstack_compute_instance_v2" "vgcn-metadata" {
  name            = "vgcnbwc-metadata-${count.index}"
  image_name      = "${var.vgcn_image}"
  flavor_name     = "m1.xlarge"
  key_pair        = "cloud2"
  security_groups = ["public"]
  count           = 2

  user_data = "${file("conf/node.yml")}"

  network {
    name = "bioinf"
  }

  provisioner "remote-exec" {
    when = "destroy"

    scripts = [
      "./conf/prepare-restart.sh",
    ]

    connection {
      type        = "ssh"
      user        = "centos"
      private_key = "${file("~/.ssh/keys/id_rsa_cloud2")}"
    }
  }
}

resource "openstack_compute_instance_v2" "vgcn-upload" {
  name            = "vgcnbwc-upload-${count.index}"
  image_name      = "${var.vgcn_image}"
  flavor_name     = "m1.xlarge"
  key_pair        = "cloud2"
  security_groups = ["public"]
  count           = 2

  user_data = "${file("conf/node.yml")}"

  network {
    name = "bioinf"
  }

  provisioner "remote-exec" {
    when = "destroy"

    scripts = [
      "./conf/prepare-restart.sh",
    ]

    connection {
      type        = "ssh"
      user        = "centos"
      private_key = "${file("~/.ssh/keys/id_rsa_cloud2")}"
    }
  }
}
