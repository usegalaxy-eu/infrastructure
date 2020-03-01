resource "openstack_compute_keypair_v2" "barcelona2020-training" {
  name       = "barcelona2020-training"
  public_key = "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABAQDO3e46pMJJsCzldoVeuki1jAU0TTmQIkzOiMSzFIhNumOcApZzFdqfTFzr5UnW2eSneGL6j6txveFbsxGaPuy7iCFlKGvWAlHHnL1pPrE424NFEuzrXq0UpTT1FdC2VQ5mR1lcUAd+aG2psGDT8YltQ/Q1dCswsBVI4YUvyPbGDJot/awQG8IAESlJP1uPkmrbsEKMSebowY2tF6o6biTnI2EHFmYqlFE5okGTqOAhCQqiIufw+aAcKi4EYsS8VmmZsWZiyKghgBtG7etdM1hQ0N7OWA+HVS/Bs92vS38U/5L5gPXGUL9RWY93RyiBxsjQf0/NxU7gEsayBY1iyUPp barecelona-admin"
}

variable "count" {
  default = 40
}

resource "random_pet" "training-vm" {
  keepers = {
    count = "${count.index}"
    image = "Ubuntu 18.04"
  }

  length = 2
  count  = "${var.count}"
}

resource "openstack_compute_instance_v2" "training-vm" {
  name            = "gat-${count.index}.training.galaxyproject.eu"
  image_name      = "Ubuntu 18.04"
  flavor_name     = "m1.xlarge"
  security_groups = ["public", "public-ping", "public-web2", "egress"]

  key_pair = "barcelona2020-training"

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

output "training_ips" {
  value = ["${openstack_compute_instance_v2.training-vm.*.access_ip_v4}"]
}

output "training_pws" {
  value     = ["${random_pet.training-vm.*.id}"]
  sensitive = true
}

resource "aws_route53_record" "training-vm" {
  zone_id = "${var.zone_galaxyproject_eu}"
  name    = "gat-${count.index}.training.galaxyproject.eu"
  type    = "A"
  ttl     = "7200"
  records = ["${element(openstack_compute_instance_v2.training-vm.*.access_ip_v4, count.index)}"]
  count   = "${var.count}"
}

resource "aws_route53_record" "training-vm-gxit-wildcard" {
  zone_id = "${var.zone_galaxyproject_eu}"
  name    = "*.interactivetoolentrypoint.interactivetool.gat-${count.index}.training.galaxyproject.eu"
  type    = "CNAME"
  ttl     = "7200"
  records = ["gat-${count.index}.training.galaxyproject.eu"]
  count   = "${var.count}"
}

output "training_dns" {
  value = ["${aws_route53_record.training-vm.*.name}"]
}
