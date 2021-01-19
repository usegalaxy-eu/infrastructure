variable "gat-count-pulsar" {
  default = 40
}

data "openstack_images_image_v2" "gat-image-pulsar" {
  name = "Ubuntu 20.04"
}

# Random passwords for the VMs, easier to type/remember for the non-ssh key
# users.
resource "random_pet" "training-vm-pulsar" {
  keepers = {
    image  = "${data.openstack_images_image_v2.gat-image-pulsar.id}"
    region = "pulsar"
  }

  length = 2
  count  = "${var.gat-count-pulsar}"
}

# The VMs themselves.
resource "openstack_compute_instance_v2" "training-vm-pulsar" {
  name            = "gat-${count.index + $var.gat-count-eu}.eu.training.galaxyproject.eu"
  image_id        = "${data.openstack_images_image_v2.gat-image-pulsar.id}"
  flavor_name     = "m1.small"
  security_groups = ["public", "public-ping", "public-web2", "egress", "public-gat", "public-amqp"]

  key_pair = "cloud2"

  network {
    name = "public"
  }

  # Update user password
  user_data = <<-EOF
    #cloud-config
    chpasswd:
      list: |
        ubuntu:${element(random_pet.training-vm-pulsar.*.id, count.index)}
      expire: False
    runcmd:
     - [ sed, -i, s/PasswordAuthentication no/PasswordAuthentication yes/, /etc/ssh/sshd_config ]
     - [ systemctl, restart, ssh ]
  EOF

  count = "${var.gat-count-pulsar}"
}

# Setup a DNS record for the VMs to make access easier (and https possible.)
resource "aws_route53_record" "training-vm-pulsar" {
  zone_id = "${aws_route53_zone.training-gxp-eu.zone_id}"
  name    = "${element(openstack_compute_instance_v2.training-vm-pulsar.*.name, count.index)}"
  type    = "A"
  ttl     = "900"
  records = ["${element(openstack_compute_instance_v2.training-vm-pulsar.*.access_ip_v4, count.index)}"]
  count   = "${var.gat-count-pulsar}"
}

# Outputs to be consumed by admins
output "training_ips-pulsar" {
  value = ["${openstack_compute_instance_v2.training-vm-pulsar.*.access_ip_v4}"]
}

output "training_pws-pulsar" {
  value     = ["${random_pet.training-vm-pulsar.*.id}"]
  sensitive = true
}

output "training_dns-pulsar" {
  value = ["${aws_route53_record.training-vm-pulsar.*.name}"]
}

