resource "openstack_compute_instance_v2" "aaaaaaaaaaaaaa" {
  name            = "vgcnbwc-training-hts2018-${count.index}"
  image_name      = "vggp-v31-j74-edc5aa3dc22c-master"
  flavor_name     = "c.c20m120"
  key_pair        = "cloud2"
  security_groups = ["public"]
  count           = 0

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
