data "openstack_images_image_v2" "anup-image" {
  name = "vggp-v60-j310-1fad751e0150-main"
}

resource "openstack_compute_instance_v2" "anup" {
  name            = "Anup dedicated VM"
  image_id        = data.openstack_images_image_v2.anup-image.id
  flavor_name     = "c1.c36m100"
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
    users:
     - default
    ssh_authorized_keys:
     - "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAACAQDC6kanRFWmhjkV8pkwOYtHoCNDIP/nj2umigbSylMFmiXm2rwnqi1qhDeJqd53PTrT4RWynT7Gqg7/HSITPAZA4wdGNcDLHD7QvexBDhIhUJCERmMZa6EWPvOPgDACbJDjrwLxd8oF65UhQU+meVrkBmpod6YDSuVIfmZXHUheK7NuZfvfNx3ruQNU5MRbI3p6vuY++B4GYRXrxM68+GWYEOEa6zz142Nl1PNnvDMkiobro0k6P5bXv4LDYMW3YyDXu69okJgPqEKjE/IsI4/2JKfzduEZMQyPZDQswyuNQwMAfKQjvDQ0gvQiVE0eM2gdR7qi/jOqFXrzkOwYWQd00Cy9EtSWqhDlpu9KrIfs8T2HTn9p/XU+Bwg4anyMh//gb+EOctpvptqoBhjNxoRTX/bwNLFq/ARFAtFDn+qX8w9HWeB5/vNvdOkH7fSMTTFmFkDZ8U/Hrg5vhcwy2Hid2K7j9peixB/41d7/O08qL99qH9362L8ZmhyT9aNeOKQ0MUEEhAasYkKO7AQcChDpkgW635mkvI5EOZGsqCRPiX8P8iTH5neH6ZI4H21JoON5E0raMJlwznNq3D4as12kZBtw198DHFAMQXlfMR24NTcv0nFnS6JmxlwCKu+Uzyt3Xlyj/wEzKYnr71vfShb3/vUgYbzIEdDQmGV8DXEJBw== anup"
  EOF
}


resource "random_id" "anup-volume_name_unique" {
  byte_length = 8
}

resource "openstack_blockstorage_volume_v2" "anup-vol" {
  name        = "anup-data-vol-${random_id.anup-volume_name_unique.hex}"
  volume_type = "default"
  description = "Data volume for anup VM"
  size        = 500
}

resource "openstack_compute_volume_attach_v2" "anup-va" {
  instance_id = openstack_compute_instance_v2.anup.id
  volume_id   = openstack_blockstorage_volume_v2.anup-vol.id
}
