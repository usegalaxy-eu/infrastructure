data "openstack_images_image_v2" "student-lr75-gpu-image" {
  name = "vggp-v31-j152-89d64435da4a-master"
}

resource "openstack_compute_instance_v2" "student-lr75-gpu" {
  name            = "student-lr75-gpu"
  image_id        = "${data.openstack_images_image_v2.student-lr75-gpu-image.id}"
  flavor_name     = "g1.n46_g1c8m20"
  key_pair        = "cloud2"
  security_groups = ["default", "public-ssh"]

  network {
    name = "public"
  }

  block_device {
    uuid                  = "${data.openstack_images_image_v2.student-lr75-gpu-image.id}"
    source_type           = "image"
    destination_type      = "local"
    boot_index            = 0
    delete_on_termination = true
  }

  block_device {
    uuid                  = "${openstack_blockstorage_volume_v2.student-lr75-gpu-vol.id}"
    source_type           = "volume"
    destination_type      = "volume"
    boot_index            = -1
    delete_on_termination = true
  }

  user_data = <<-EOF
    #cloud-config
    disk_setup:
      /dev/vdb:
        table_type: mbr
        layout: True
        overwrite: True
    fs_setup:
     - label: None
       filesystem: ext4
       device: /dev/vdb
       partition: none
    mounts:
     - [ /dev/vdb, /scratch, ext4, "defaults", "0", "2" ]
    runcmd:
     - mkdir -p /scratch/users
     - chmod 0777 /scratch/users
    package_update: true
    package_upgrade: true
    users:
     - default
     - name: user
       shell: /bin/bash
       lock_passwd: true
       ssh_authorized_keys:
         - "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAACAQC8MtPcL4AY97vB1tlDqKQteMUcBICmSDv4+oANJe61vwr/KmmnAi9oQIM/WV3jnnKlrX9rDSc9+9vOfddFp3vjq/nSQ0orq1jsrKsGKYvihBrf3cqMiog2GpA8honAFpSh479oVjLf+uyDJRpmVmf5oh9nLZxmmYd+mw+AkugsVj1gOuYamgmP2mBl8ViIXw6q4z4Bb7RNo8LtFa06mUFV//zT23+C5nVzN4xymVuVsUfPWvvyD3kzmqnML21Q7fXwSzeA/UjdJfwBvFJv4yzqFoWOC3gHHJl810afPQsERQQOHInoTJ6j0+VHX5Nxe7ckD33KDwdTsHhlRD9hJTRw/ueW7VAOyGdy4zrxYrOQHkbnP9C6i+GW6HK3xxCMZaLL5WKigEgcNr65gd4bebjBn0SmpxtVRjd+2Vi1W92PnCLVwqUXvxHSX4XKFuLo0sFoLIrfaIqA/51LYIg0QNIGq+vS1dDnEEUpJlSvXl90h39XC0dHyvwreAsUVmNSjAiZ6jhdzidcQ2Oc4u677NkmuvuAwA2NqsNbbPfHeDOHvawgPwQ+IUCJIdGegbwtgJ9S8Ov5YDA41dfdaDGlP+VKsmo+0Js1Rp1Fnc3i/kToKjAJVRusLMIWHvYaDNc7OLdyY9ALBJjkHP1Pg7V1iRYDzJk3nyG0Tlkr9lgpnbi3Vw=="
  EOF
}

resource "random_id" "student-lr75-gpu-volume_name_unique" {
  byte_length = 8
}

resource "openstack_blockstorage_volume_v2" "student-lr75-gpu-vol" {
  name = "student-lr75-gpu-scratch-vol-${random_id.student-lr75-gpu-volume_name_unique.hex}"
  volume_type = "default"
  size = 100
}
