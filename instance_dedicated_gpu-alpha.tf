variable "gpu-node-alpha-dns" {
  default = "gpu-node-alpha.galaxyproject.eu"
}

data "openstack_images_image_v2" "gpu-node-alpha-image" {
  name = "vggp-gpu-v60-j310-1fad751e0150-main"
}

resource "openstack_compute_instance_v2" "gpu-node-alpha" {
  name            = var.gpu-node-alpha-dns
  flavor_name     = "g1.c36m100g1"
  key_pair        = "cloud2"
  security_groups = ["default", "public-ssh"]

  network {
    name = "public"
  }

  user_data = <<-EOF
    #cloud-config
    bootcmd:
        - test -z "$(blkid /dev/vdb)" && mkfs -t ext4 /dev/vdb
        - mkdir -p /scratch
    mounts:
        - ["/dev/vdb", "/scratch", auto, "defaults,nofail", "0", "2"]
    runcmd:
        - [ chown, "centos.centos", -R, /scratch ]
    package_update: true
    package_upgrade: true
    packages:
    - cuda-11-6
    - nvidia-container-toolkit
    users:
     - default
    ssh_authorized_keys:
     - "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAACAQDC6kanRFWmhjkV8pkwOYtHoCNDIP/nj2umigbSylMFmiXm2rwnqi1qhDeJqd53PTrT4RWynT7Gqg7/HSITPAZA4wdGNcDLHD7QvexBDhIhUJCERmMZa6EWPvOPgDACbJDjrwLxd8oF65UhQU+meVrkBmpod6YDSuVIfmZXHUheK7NuZfvfNx3ruQNU5MRbI3p6vuY++B4GYRXrxM68+GWYEOEa6zz142Nl1PNnvDMkiobro0k6P5bXv4LDYMW3YyDXu69okJgPqEKjE/IsI4/2JKfzduEZMQyPZDQswyuNQwMAfKQjvDQ0gvQiVE0eM2gdR7qi/jOqFXrzkOwYWQd00Cy9EtSWqhDlpu9KrIfs8T2HTn9p/XU+Bwg4anyMh//gb+EOctpvptqoBhjNxoRTX/bwNLFq/ARFAtFDn+qX8w9HWeB5/vNvdOkH7fSMTTFmFkDZ8U/Hrg5vhcwy2Hid2K7j9peixB/41d7/O08qL99qH9362L8ZmhyT9aNeOKQ0MUEEhAasYkKO7AQcChDpkgW635mkvI5EOZGsqCRPiX8P8iTH5neH6ZI4H21JoON5E0raMJlwznNq3D4as12kZBtw198DHFAMQXlfMR24NTcv0nFnS6JmxlwCKu+Uzyt3Xlyj/wEzKYnr71vfShb3/vUgYbzIEdDQmGV8DXEJBw== anup"
     - "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABgQCsMik6vRSs9RCmajIqJ5d20bnRheUV1t1kE042Av35peN03kklYlgFkvt7czs88ty6X2mit3Gpf/U+lwADh3LObxAc48qfj5gvfJ5EzPXTVoV7NYvjpnm+LujqAt+q+K3Gg3XpGmQGrT3Y/dwcPyvhUjYAWvf/zXr/TpEfwwj05wWIkIAn2lrTIkZNu6dT28ARb4JHyQMtcA7A7tkZwqC4ybf9YMMuUJpZHZ3l1pMvD7/ZY+a5oq/n/oOd/piPu6ESacy5fLyWFElNJM7hDCIuoiYG8tv0dQVvbGcs4iIX6Dw1BLfavhLNV9NM0iEFLql4ntZA2iHaKDrz8Ci2Qlo5lQjXPDYc4Um1gQxzGvSPVbAdzcUmA3d+p4kFKXk1Za/fLO7Se39w4YM21pTPKFYFEFapcLZC3+QFSzDFPdnwPzbL46wBk/8mluvZVZ/tYqQGtSe/CyBYzsYPVfqtVxg4gWzITAFKDhC3QlH8rRz61hxSG/1y7RPR/p9UxbsBghk= kxk302@Kaivans-MacBook-Pro.local"
  EOF
}

resource "random_id" "gpu-node-alpha-volume_name_unique" {
  byte_length = 8
}

resource "openstack_blockstorage_volume_v2" "gpu-node-alpha-vol" {
  name        = "gpu-node-alpha-scratch-vol-${random_id.gpu-node-alpha-volume_name_unique.hex}"
  volume_type = "default"
  description = "Scratch volume for gpu-node-alpha"
  size        = 1024
}

resource "openstack_compute_volume_attach_v2" "gpu-node-alpha-internal-va" {
  instance_id = openstack_compute_instance_v2.gpu-node-alpha.id
  volume_id   = openstack_blockstorage_volume_v2.gpu-node-alpha-vol.id
}

resource "aws_route53_record" "gpunodealpha" {
  zone_id = var.zone_galaxyproject_eu
  name    = var.gpu-node-alpha-dns
  type    = "A"
  ttl     = "600"
  records = ["${openstack_compute_instance_v2.gpu-node-alpha.access_ip_v4}"]
}
