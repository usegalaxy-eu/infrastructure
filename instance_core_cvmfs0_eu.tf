variable "cvmfs-stratum0-eu-dns" {
  default = "cvmfs-stratum0.galaxyproject.eu"
}

resource "openstack_compute_instance_v2" "cvmfs-stratum0-eu" {
  name            = var.cvmfs-stratum0-eu-dns
  image_name      = "cvmfs-stratum0_22_04_2024"
  flavor_name     = "m1.small"
  key_pair        = "cloud2"
  security_groups = ["egress", "public-ssh", "public-ping", "public-web2"]

  network {
    name = "public-extended"
  }

  user_data = <<-EOF
    #cloud-config
    users:
     - default
    ssh_authorized_keys:
     - "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAACAQDhyhYQ8GT480B1rTYQQxGoQqeEMzMBEkVn9nRbSK35xyoLgDQyFyZ2QJ+9Y6GAHtnwnaXhutVrYwiKfpEFTWhoUsAWXvTFa81NPwkY04tIf0rrbEyu2chwYVeAjsXX0QKMuAjtN8t4JqnpmUugeDDPvU+1L5Sp3vVkFKJBou5y+4m9ROuitFrE86cqMAQUhuTXYaQjm8gl287hko3acPRC71xUljEosXPgvZLsqRrgX0IBtgUn9tswKSO7WNddDjuuSpSPG9T+81Ack5XDdENgq6qY6L6KwJO0LDkYg8FbadaUi+JXiwsVmsVAsjhDYeRsJvSPbnLg7wbdW6htr7bU6aIv3xc3jOGLUmqDhBQ89iY6cpB0h/7QHGT69RezTgFmEzMKh2fTE+mAivOCe3UBn9aZxl4Cjwr+y9CSA9iQ09V2TVXf3CdHUwW+HehjVJycV0nckJ5U7C+qALj9+hiNftoMwFymyNmvQLKpgwsjDcenQ6uXCTXSoH6Mc4v9gErWIC/090jK2lOYQ2YlbPpxrqwRE5pK6d982wqCTBhNYKZYZGiGq8B8IX76QiA2hltUT202QqOhCdWvIfmllOEf1aKzbB2o8ktILx0ECNJpe8vVS4DMKyB9FmIz86mXVadnlnzhTNEWJpmehlvOf3gFu+sZaSz9+hoz1eO5RBBgcw== natefoo"
  EOF
}

# 22.4.2024: This resource creation is commented out because the volume
# from the old cloud is being attached to the instance in the new cloud.
# resource "openstack_blockstorage_volume_v2" "cvmfs-data-eu" {
#   name        = "cvmfs stratum 0 EU"
#   description = "spool space for cvmfs"
#   size        = 500
# }

resource "openstack_compute_volume_attach_v2" "cvmfs-stratum0-va-eu" {
  instance_id = openstack_compute_instance_v2.cvmfs-stratum0-eu.id
  volume_id   = "b637697c-5227-4b0c-a300-7afdd2256cc4"
  device      = "/dev/vdb"
}

resource "aws_route53_record" "cvmfs-stratum0-eu" {
  allow_overwrite = true
  zone_id         = aws_route53_zone.zone_galaxyproject_eu.zone_id
  name            = var.cvmfs-stratum0-eu-dns
  type            = "A"
  ttl             = "600"
  records         = ["${openstack_compute_instance_v2.cvmfs-stratum0-eu.access_ip_v4}"]
}
