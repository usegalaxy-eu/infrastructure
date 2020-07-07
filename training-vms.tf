variable "count" {
  default = 36
}

# Random passwords for the VMs, easier to type/remember for the non-ssh key
# users.
resource "random_pet" "training-vm" {
  keepers = {
    count = "${count.index}"
    image = "Ubuntu 18.04"
  }

  length = 2
  count  = "${var.count}"
}

# The VMs themselves.
resource "openstack_compute_instance_v2" "training-vm" {
  name            = "gat-${count.index}.training.galaxyproject.eu"
  image_name      = "Ubuntu 18.04"
  flavor_name     = "m1.xlarge"
  security_groups = ["public", "public-ping", "public-web2", "egress"]

  key_pair = "cloud2"

  network {
    name = "public"
  }

  # Update user password
  user_data = <<-EOF
    #cloud-config
    chpasswd:
      list: |
        ubuntu:${element(random_pet.training-vm.*.id, count.index)}
      expire: False
    runcmd:
     - [ sed, -i, s/PasswordAuthentication no/PasswordAuthentication yes/, /etc/ssh/sshd_config ]
     - [ systemctl, restart, ssh ]
  EOF

  count = "${var.count}"
}

# Setup a DNS record for the VMs to make access easier (and https possible.)
resource "aws_route53_record" "training-vm" {
  zone_id = "${var.zone_galaxyproject_eu}"
  name    = "gat-${count.index}.training.galaxyproject.eu"
  type    = "A"
  ttl     = "7200"
  records = ["${element(openstack_compute_instance_v2.training-vm.*.access_ip_v4, count.index)}"]
  count   = "${var.count}"
}

# Only for the REAL gat.
#resource "aws_route53_record" "training-vm-gxit-wildcard" {
#zone_id = "${var.zone_galaxyproject_eu}"
#name    = "*.interactivetoolentrypoint.interactivetool.gat-${count.index}.training.galaxyproject.eu"
#type    = "CNAME"
#ttl     = "7200"
#records = ["gat-${count.index}.training.galaxyproject.eu"]
#count   = "${var.count}"
#}

# Testing a single CentOS8 VM
resource "openstack_compute_instance_v2" "training-vm-centos" {
  name            = "c8.gat-${count.index}.training.galaxyproject.eu"
  image_name      = "CentOS 8"
  flavor_name     = "m1.xlarge"
  security_groups = ["public", "public-ping", "public-web2", "egress"]

  key_pair = "cloud2"

  network {
    name = "public"
  }
}

# Testing a single CentOS7 VM
resource "openstack_compute_instance_v2" "training-vm-centos7" {
  name            = "c7.gat-${count.index}.training.galaxyproject.eu"
  image_name      = "CentOS 7"
  flavor_name     = "m1.xlarge"
  security_groups = ["public", "public-ping", "public-web2", "egress"]

  key_pair = "cloud2"

  network {
    name = "public"
  }
}

# Outputs to be consumed by admins
output "training_ips" {
  value = ["${openstack_compute_instance_v2.training-vm.*.access_ip_v4}"]
}

output "training_pws" {
  value     = ["${random_pet.training-vm.*.id}"]
  sensitive = true
}

output "training_dns" {
  value = ["${aws_route53_record.training-vm.*.name}"]
}
