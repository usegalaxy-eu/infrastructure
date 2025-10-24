variable "gat-count-eu" {
  default = 10
}

data "openstack_images_image_v2" "gat-image-eu" {
  name = "Ubuntu 24.04"
}


# Random passwords for the VMs, easier to type/remember for the non-ssh key
# users.
resource "random_pet" "training-vm-eu" {
  keepers = {
    image  = "${data.openstack_images_image_v2.gat-image-eu.id}"
    region = "eu"
  }
  length = 2
  count  = var.gat-count-eu
}

# The VMs themselves.
resource "openstack_compute_instance_v2" "training-vm-eu" {
  name            = "gat-${count.index}.eu.training.galaxyproject.eu"
  flavor_name     = "m1.xlarge"
  key_pair        = "gat"
  security_groups = ["default", "public-ping", "public-web2", "egress", "public-amqp"]

  network {
    name = "public"
  }

  block_device {
    uuid                  = data.openstack_images_image_v2.gat-image-eu.id
    source_type           = "image"
    volume_size           = 50
    destination_type      = "volume"
    boot_index            = 0
    delete_on_termination = true
  }

  # Update user password
  user_data = <<-EOF
    #cloud-config
    chpasswd:
      list: |
        ubuntu:${element(random_pet.training-vm-eu.*.id, count.index)}
      expire: False
    runcmd:
     - [ sed, -i, s/PasswordAuthentication no/PasswordAuthentication yes/, /etc/ssh/sshd_config ]
     - [ sed, -i, s/PasswordAuthentication no/PasswordAuthentication yes/, /etc/ssh/sshd_config.d/60-cloudimg-settings.conf ]
     - [ systemctl, restart, ssh ]
  EOF

  count = var.gat-count-eu
}

# Setup a DNS record for the VMs to make access easier (and https possible.)
resource "aws_route53_record" "training-vm-eu" {
  zone_id = "Z05016927AMHTHGB1IS2"
  name    = "gat-${count.index}.eu.training.galaxyproject.eu"
  type    = "A"
  ttl     = "3600"
  records = ["${element(openstack_compute_instance_v2.training-vm-eu.*.access_ip_v4, count.index)}"]
  count   = var.gat-count-eu
}

## Only for the REAL gat.
#resource "aws_route53_record" "training-vm-eu-gxit-wildcard" {
#  zone_id = aws_route53_zone.training-gxp-eu.zone_id
#  name    = "*.interactivetoolentrypoint.interactivetool.gat-${count.index}.eu.training.galaxyproject.eu"
#  type    = "CNAME"
#  ttl     = "3600"
#  records = ["gat-${count.index}.eu.training.galaxyproject.eu"]
#  count   = var.gat-count-eu
#}

# Outputs to be consumed by admins
output "training_ips-eu" {
  value = ["${openstack_compute_instance_v2.training-vm-eu.*.access_ip_v4}"]
}

output "training_pws-eu" {
  value     = ["${random_pet.training-vm-eu.*.id}"]
  sensitive = true
}

output "training_dns-eu" {
  value = ["${aws_route53_record.training-vm-eu.*.name}"]
}

