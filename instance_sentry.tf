data "openstack_images_image_v2" "centos-image" {
  name = "${var.centos_image}"
}

resource "openstack_compute_instance_v2" "sentry-usegalaxy" {
  name            = "sentry.galaxyproject.eu"
  image_id        = "${data.openstack_images_image_v2.centos-image.id}"
  flavor_name     = "m1.small"
  key_pair        = "cloud2"
  security_groups = "${var.sg_webservice}"

  network {
    name = "public"
  }

  block_device {
    uuid                  = "${data.openstack_images_image_v2.centos-image.id}"
    source_type           = "image"
    destination_type      = "local"
    boot_index            = 0
    delete_on_termination = true
  }

  block_device {
    uuid                  = "${openstack_blockstorage_volume_v2.sentry_volume_data.id}"
    source_type           = "volume"
    destination_type      = "volume"
    boot_index            = -1
    delete_on_termination = true
  }

  user_data = <<-EOF
  #cloud-config
  write_files:
  - content: |
      /dev/vdb  /data/vol xfs defaults,nofail 0 2
    owner: root:root
    path: /etc/fstab
    permissions: '0644'

  runcmd:
   - [mkfs, -t, xfs, /dev/vdb]
   - [mkdir, -p, /data/vol]
   - [mount,  /data/vol]
   - [chown,  "centos:centos", -R, /data/vol]
  EOF
}

resource "openstack_blockstorage_volume_v2" "sentry_volume_data" {
  name        = "sentry_volume"
  description = "Data volume for Sentry"
  size        = "10"
}

resource "aws_route53_record" "sentry-usegalaxy" {
  zone_id = "${var.zone_galaxyproject_eu}"
  name    = "sentry.galaxyproject.eu"
  type    = "A"
  ttl     = "7200"
  records = ["${openstack_compute_instance_v2.sentry-usegalaxy.access_ip_v4}"]
}
