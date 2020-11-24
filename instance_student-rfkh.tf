data "openstack_images_image_v2" "student-rfkh-image" {
  name = "vggp-v31-j152-89d64435da4a-master"
}

resource "openstack_compute_instance_v2" "student-rfkh" {
  name            = "student-rfkh"
  image_id        = "${data.openstack_images_image_v2.student-rfkh-image.id}"
  flavor_name     = "g1.n46_g1c8m20"
  key_pair        = "cloud2"
  security_groups = ["default", "public-ssh"]

  network {
    name = "public"
  }

  block_device {
    uuid                  = "${data.openstack_images_image_v2.student-rfkh-image.id}"
    source_type           = "image"
    destination_type      = "local"
    boot_index            = 0
    delete_on_termination = true
  }

  block_device {
    uuid                  = "${openstack_blockstorage_volume_v2.student-rfkh-vol.id}"
    source_type           = "volume"
    destination_type      = "volume"
    boot_index            = -1
    delete_on_termination = true
  }

  user_data = <<-EOF
    #cloud-config
    packages:
     - cuda-10-1
     - nvidia-container-toolkit
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
     - name: rfkh
       shell: /bin/bash
       lock_passwd: true
       ssh_authorized_keys:
         - "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAACAQC5ZMgq9AQgVOQDqQGJn/PYtUC08IAYxjl81i77xCyVeiJO2s6+rPLCFMhEC00xK/eo6E/VEXw4LOAA/ubzN0Et08ablvPl7+hYU+AvqECRlLmq43sPdN9Mk52kHFUFw0Zex8b7T8ZG4mUeqgQggUZre+k9TD5xu3n3mywcThGK5h+bFRVtpU+2pKPwG+XA0D2iKJkf0A5eV1zdzFmKpfzwnHQuV1TNvxl+uBi3WFC6koss4Q7ozlmIFq5J6V1GtFMpnMXAvwDQqLKdPWbOwU9slSdute9/4UPSnVy7hzGIeioKkepi/y9kYjaiiQoOzhaaru0o7gFBT+S90ZS02OYcCsBBt+rASDLRhCny6ZA0QAfBwNo6rD3ek5Ys0x1CC70JJ11QbeGWheRrRCuUvfI3GzXHC5+bWTBT6X+ndusKfPvCYjCwvIbT1NUb76T4Cxnbb/rwKtZIcnRnmF4ecr/jTfMiYi7YAgkOHggTI+K6KI9g7N8h/h7iSNPCXEOb2BYfeeVT81q2nyNI0AcV3NvQr8RGriFCXgi58f/ReujvxVkDFzLUE1JjV5FKSvUlZfBEYvXmoroCLZ9NkIKIf69mojnVbhXdStrYa4vOvuNY1jnzIAbWIW4OpQ/X+xfPHo1pyLZ+7Mjo60HCm+rV5izdsXRjtcvE4VbySgV2KNJl1w=="
  EOF
}

resource "random_id" "student-rfkh-volume_name_unique" {
  byte_length = 8
}

resource "openstack_blockstorage_volume_v2" "student-rfkh-vol" {
  name = "student-rfkh-scratch-vol-${random_id.student-rfkh-volume_name_unique.hex}"
  size = 500
}
