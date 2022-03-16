variable "student-sprsd-dns" {
  default = "student-sprsd-vm"
}

variable "student-sprsd-volume-size" {
  default = 200
}

resource "openstack_compute_instance_v2" "student-sprsd-instance" {
  name            = var.student-sprsd-dns
  flavor_name     = "m1.xlarge"
  image_name      = "Ubuntu 20.04"
  key_pair        = "cloud2"
  security_groups = ["default", "public-ssh"]

  network {
    name = "public"
  }

  user_data = <<-EOF
    #cloud-config
    package_update: true
    package_upgrade: true
    users:
     - default
    ssh_authorized_keys:
     - "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABAQDQqZ3WwlEy+iBdq6pRfVfOvZ6xa7J9Gw0hTGaetWvt/PdmYx77qxNr9KQOMtnhy4/+EGS2j+ykBZtrNq72pZ7WHar9/C412ktMx5WK416KMThGPiLt2oQEblRlMKOnwf9/D8xUNQcLytDhksZLWo0dy6EE2TakZ15XMvuhihXiPAzEdAhg7pE8hhJYvJOcru5RSKdUynxHS2oCyrKu5wujM+CXarRxNM3ZoEzdPHUZAsvUDlVmWMy5gsm8xZREFrv068gX7iX6eVvA/g53empcfWAuGc3Xkxs+jQOgh/Iul10EzU+nqQcBbvkrcnKXFwkD0ij0dCYBJL59my5sjjqZ saint@saint-Strix-GL504GV-GL504GV"
    bootcmd:
        - test -z "$(blkid /dev/vdb)" && mkfs -t xfs /dev/vdb
        - mkdir -p /scratch
    mounts:
        - ["/dev/vdb", "/scratch", auto, "defaults,nofail", "0", "2"]
    runcmd:
        - [ chown, "centos.centos", -R, /scratch ]
        - [ chmod, "a+rw", /scratch ]
  EOF
}

resource "openstack_blockstorage_volume_v2" "student-sprsd-volume" {
  name        = "student-sprsd-volume"
  description = "Data volume for student-sprsd instance"
  volume_type = "default"
  size        = var.student-sprsd-volume-size
}

resource "openstack_compute_volume_attach_v2" "student-sprsd-va" {
  instance_id = openstack_compute_instance_v2.student-sprsd-instance.id
  volume_id   = openstack_blockstorage_volume_v2.student-sprsd-volume.id
}
