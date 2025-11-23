variable "gat-trainee-count-eu" {
  default = 18
}

variable "gat-trainee-zone-id-eu" {
  default = "Z05016927AMHTHGB1IS2"
}

data "openstack_images_image_v2" "gat-trainee-image-eu" {
  name = "Ubuntu 24.04"
}


# Random passwords for the VMs, easier to type/remember for the non-ssh key
# users.
resource "random_pet" "training-trainee-vm-eu" {
  keepers = {
    image  = "${data.openstack_images_image_v2.gat-trainee-image-eu.id}"
    region = "eu"
  }
  length = 2
  count  = var.gat-trainee-count-eu
}

# The VMs themselves.
resource "openstack_compute_instance_v2" "training-trainee-vm-eu" {
  name            = "gat-${count.index + var.gat-count-eu}.eu.training.galaxyproject.eu"
  flavor_name     = "m1.xlarge"
  key_pair        = "gat"
  security_groups = ["default", "public-ping", "public-web2", "egress", "public-amqp"]

  network {
    name = "public"
  }

  block_device {
    uuid                  = data.openstack_images_image_v2.gat-trainee-image-eu.id
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
        ubuntu:${element(random_pet.training-trainee-vm-eu.*.id, count.index + var.gat-count-eu)}
      expire: False
    runcmd:
     - [ sed, -i, s/PasswordAuthentication no/PasswordAuthentication yes/, /etc/ssh/sshd_config ]
     - [ sed, -i, s/PasswordAuthentication no/PasswordAuthentication yes/, /etc/ssh/sshd_config.d/60-cloudimg-settings.conf ]
     - [ systemctl, restart, ssh ]
  EOF

  count = var.gat-trainee-count-eu
}

# Setup a DNS record for the VMs to make access easier (and https possible.)
resource "aws_route53_record" "training-trainee-vm-eu" {
  zone_id = var.gat-zone-id-eu
  name    = "gat-${count.index + var.gat-count-eu}.eu.training.galaxyproject.eu"
  type    = "A"
  ttl     = "3600"
  records = ["${element(openstack_compute_instance_v2.training-trainee-vm-eu.*.access_ip_v4, count.index + var.gat-count-eu)}"]
  count   = var.gat-trainee-count-eu
}

resource "aws_route53_record" "training-trainee-vm-eu-gxit-wildcard" {
  zone_id = var.gat-zone-id-eu
  name    = "*.ep.interactivetool.gat-${count.index + var.gat-count-eu}.eu.training.galaxyproject.eu"
  type    = "CNAME"
  ttl     = "3600"
  records = ["gat-${count.index + var.gat-count-eu}.eu.training.galaxyproject.eu"]
  count   = var.gat-trainee-count-eu
}

# Outputs to be consumed by admins
output "training_ips-trainee-eu" {
  value = ["${openstack_compute_instance_v2.training-trainee-vm-eu.*.access_ip_v4}"]
}

output "training_pws-trainee-eu" {
  value     = ["${random_pet.training-trainee-vm-eu.*.id}"]
  sensitive = true
}

output "training_dns-trainee-eu" {
  value = ["${aws_route53_record.training-trainee-vm-eu.*.name}"]
}

