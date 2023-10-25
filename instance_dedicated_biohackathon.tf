data "openstack_images_image_v2" "biohackathon-image" {
  name = "Rocky 9.0"
}

resource "openstack_compute_instance_v2" "biohackathon" {
  name            = "biohackathon 2023 dedicated VM"
  image_id        = data.openstack_images_image_v2.biohackathon-image.id
  flavor_name     = "c1.c36m100d50"
  key_pair        = "cloud2"
  security_groups = ["default"]

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
        - [ chown, "rocky.rocky", -R, /scratch ]
    package_update: true
    package_upgrade: true
    users:
     - default
    ssh_authorized_keys:
     - "ecdsa-sha2-nistp521 AAAAE2VjZHNhLXNoYTItbmlzdHA1MjEAAAAIbmlzdHA1MjEAAACFBAGHsfT+pkgaWoeMSTcbMCVidZFpCb6DWBChBzi5OQPctj6h66NfuE4S2LDY1dr9ZpfRTu3+4J6ucB9LOLcKWtVS5AAErBxZ72YEu9jGEZqgcrPvJuASDcLy01K0YczJFmxpOPepIJhPGSFPgHaUUW4t4qMjUGxxutbAXhyMkl6/PiMucA== biohackathon"
  EOF
}


resource "random_id" "biohackathon-volume_name_unique" {
  byte_length = 8
}

resource "openstack_blockstorage_volume_v2" "biohackathon-vol" {
  name        = "biohackathon-data-vol-${random_id.biohackathon-volume_name_unique.hex}"
  volume_type = "default"
  description = "Data volume for biohackathon VM"
  size        = 1000
}

resource "openstack_compute_volume_attach_v2" "biohackathon-va" {
  instance_id = openstack_compute_instance_v2.biohackathon.id
  volume_id   = openstack_blockstorage_volume_v2.biohackathon-vol.id
}
