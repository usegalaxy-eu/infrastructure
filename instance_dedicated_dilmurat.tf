data "openstack_images_image_v2" "dilmurat-image" {
  name = "vggp-gpu-v60-j310-1fad751e0150-main"
}

resource "openstack_compute_instance_v2" "dilmurat" {
  name            = "dilmurat dedicated VM"
  image_id        = data.openstack_images_image_v2.dilmurat-image.id
  flavor_name     = "g1.c8m20g1"
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
     - "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABAQDsA6YIRNmm4Bfxh9uD0EFD/0+mChsJzxBIE6zjrXpwpsuGI0mKFIIZv+S+CearHMNO4KmsfOafXuaqaiFbGcBAi2bzP4GRNGje/FDz+OWi1r0GyQyzy/P7ORMsbTX3otR/gfgQN6fIUe6Qsbpcf6xwTFhJhIWrqRvr1+t1LQSR7DwNcLpdlS8g/QMW4Z/l/Ll6nMTv3sdunE+BXGFBdHN/luDpKOsz0kshYHLaKuw08+zRE6fBuxpnxEkHXkscMA7qFDiOrhe0vdL+FoAQ7yxUOV2h7HlLF4yDNXVsqeWogWXXNY8S/6zc+mGL2Kxrljew5b6EQfcgJTmkHIx46ZbX cuyghur@bilp34"
  EOF
}


resource "random_id" "dilmurat-volume_name_unique" {
  byte_length = 8
}

resource "openstack_blockstorage_volume_v2" "dilmurat-vol" {
  name        = "dilmurat-data-vol-${random_id.dilmurat-volume_name_unique.hex}"
  volume_type = "default"
  description = "Data volume for dilmurat VM"
  size        = 200
}

resource "openstack_compute_volume_attach_v2" "dilmurat-va" {
  instance_id = openstack_compute_instance_v2.dilmurat.id
  volume_id   = openstack_blockstorage_volume_v2.dilmurat-vol.id
}
