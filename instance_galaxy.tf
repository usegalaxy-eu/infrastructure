data "openstack_images_image_v2" "centos-image-new" {
  name = "${var.centos_image_new}"
}

resource "openstack_compute_instance_v2" "test-galaxy" {
  name            = "test.internal.usegalaxy.eu"
  image_name      = "${var.centos_image_new}"
  flavor_name     = "m1.large"
  key_pair        = "cloud2"
  security_groups = ["egress", "public-web2", "ufr-ingress", "public-ping"]

  network {
    name = "bioinf"
  }
    block_device {
    uuid                  = "${data.openstack_images_image_v2.centos-image-new.id}"
    source_type           = "image"
    destination_type      = "local"
    boot_index            = 0
    delete_on_termination = true
  }

  block_device {
    uuid                  = "${openstack_blockstorage_volume_v2.test-galaxy_volume_data.id}"
    source_type           = "volume"
    destination_type      = "volume"
    boot_index            = -1
    delete_on_termination = true
  }

  user_data = <<-EOF
  #cloud-config
  write_files:
  - content: |
      /dev/vdb  /opt xfs defaults,nofail 0 2
    owner: root:root
    path: /etc/fstab
    permissions: '0644'

  runcmd:
   - [mkfs, -t, xfs, /dev/vdb]
   - [mkdir, -p, /opt]
   - [mount,  /opt]
   - [chown,  "root:root", -R, /opt]
  EOF
}

resource "openstack_blockstorage_volume_v2" "test-galaxy_volume_data" {
  name        = "test-galaxy_volume"
  description = "Data volume for test.usegalaxy.eu"
  size        = "100"
}

resource "aws_route53_record" "test-galaxy" {
  zone_id = "${var.zone_usegalaxy_eu}"
  name    = "test.internal.usegalaxy.eu"
  type    = "A"
  ttl     = "600"
  records = ["${openstack_compute_instance_v2.test-galaxy.access_ip_v4}"]
}
