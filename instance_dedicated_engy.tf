# This is a project (HPylori) VM for Engy.
data "openstack_images_image_v2" "engy-image" {
  name = "Ubuntu 24.04"
}

resource "openstack_compute_instance_v2" "engy" {
  name            = "engy-dedicated-VM"
  image_id        = data.openstack_images_image_v2.engy-image.id
  flavor_name     = "c1.c36m100d50"
  key_pair        = "cloud2"
  security_groups = ["default"]

  network {
    name = "bioinf"
  }

  user_data = <<-EOF
    #cloud-config
    bootcmd:
        - test -z "$(blkid /dev/vdb)" && mkfs -t ext4 /dev/vdb
        - mkdir -p /data
    mounts:
        - ["/dev/vdb", "/data", auto, "defaults,nofail", "0", "2"]
    runcmd:
        - [ chown, "ubuntu.ubuntu", -R, /data ]
    package_update: true
    package_upgrade: true
    users:
     - default
    ssh_authorized_keys:
     - "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABgQCtMvCQL1Xw/DrzO/U4nfyIL6CE63apSXHjQByWK+vWpfNkBjMh4uwQl6SzWvCn6y7tlMko1P6BG9bVDkWLLjC/kL+ds+FXDwUyLmRcfyhkortBVMWrZO3ZSSimpFugPDcfUeh+iim/Jg2CY1geVmlA9bybY8k0hGTKa5rn9KzbLCoZdsR1c9627PAefV9lr7xTHMamWsG0cIYjkOBqZM85Yw9huftUGZi1SAALjiG3k57XFswZcHrvZkE/L5Q5uU9NC0KYVapzG9PYmgU+O40Oi82PB4C6SWoOM0MG39AIS4DU7DstF3mrl2M/6crbcHIfVTB+GCQI2U9CzfvlhA6qQu+xlAc4ZX/rXeYZvNW6QtU1vvUcL95wSrPyXlqlSA6o/0T0EP8e2LG2JpNtzorcLrj010fWdpH1jY/c9ZACYNmCPuUTD/ASt5FXCqPR0WJnf4Mle10ALmghsbm7vLXQUKDcQSC4bJKpgzdFT2ocmk9jiGqCq3hivSVmR6OvHok= engy"
     - "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAACAQCWFs0yjH15DB+Jx1Ttw07TYsg0v5ZYuUnMEpHyWXuS+G+LvnPg0ghM9ACpbdTV22iD6p/MZMkX682BrBDD1vxPYc1IzKy/IJbteBPRD7XBnkt22Xqbyp+2fv04WFZFEbdOqH3E342gAYmrTe5kQosmvzGY6r+B2LM+phbYRYKevQKd5bATiiHiqgWJW/jDDoe31uS278cLRxmXk8nTCW0ncWXTAdtKnPJdv0BRsevK8e0rmTxSo2AVY5J1QRBLuGOcfI7MQJZ3qTwhwbUtr5JEmYLcMg6gieU3pjxRe7a3TiB+zO7u58sAg5ZtUr3pfV99hLG1cdWkIXHS3A/HgIqNBgqOahp4CEElL8jVMTToUT+Xd0/LLKOmaEembrHB8VsHKW4LjRo6RCZZNKCQKMRIR2zFiMD/8s49KcbNFgzfjnX8p7feMaTl9uaft4tETumLHN2gs8COivnV2edlWPLDA4L4XS6EHaw4zlC3JTQRBonT3PCZbAf9HuzeHN6aM/W8TJp2L1OWawjv0Q2PNLmB5eQNVzxqlLLH8MDwsVe9+zygfvNb3gnU6uWm6Y3GtnkjdDD59Hk2ztfm0h5IV3kDLXNTx2V74N3O6J0K+66xexGIEmCUUo6AbV1gHnH5f+6qbPKn91wtQp5XGrkrv9p3WjrYBDnows9KqsczM0unVw== nasr"
  EOF
}


resource "random_id" "engy-volume-name-unique" {
  byte_length = 8
}

resource "openstack_blockstorage_volume_v3" "engy-vol" {
  name        = "engy-data-vol-${random_id.engy-volume-name-unique.hex}"
  volume_type = "default"
  description = "Data volume for engy VM"
  size        = 500
}

resource "openstack_compute_volume_attach_v2" "engy-va" {
  instance_id = openstack_compute_instance_v2.engy.id
  volume_id   = openstack_blockstorage_volume_v3.engy-vol.id
  device      = "/dev/vdb"
}