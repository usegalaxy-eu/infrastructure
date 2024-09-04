resource "openstack_compute_instance_v2" "influxdb-usegalaxy-new" {
  name            = "influxdb.galaxyproject.eu"
  image_name      = "2196b5f5-402c-4e2e-b426-e75bf8b55eea"
  flavor_name     = "m1.xlarge"
  key_pair        = "cloud2"
  security_groups = ["egress", "public-ssh", "public-ping", "public-influxdb", "public-web2"]

  lifecycle {
        ignore_changes = [power_state]
  }

  network {
    name = "public"
  }

  user_data = <<-EOF
    #cloud-config
    bootcmd:
        - test -z "$(blkid /dev/vdb)" && mkfs -t ext4 /dev/vdb
        - mkdir -p /data
    mounts:
        - ["/dev/vdb", "/data", auto, "defaults,nofail", "0", "2"]
    runcmd:
        - [ chown, "centos.centos", -R, /data ]
    package_update: true
    package_upgrade: true
  EOF
}

 resource "openstack_blockstorage_volume_v3" "influxdb-data-new" {
   name        = "influxdb-new"
   description = "Data volume for InfluxDB"
   size        = 200
 }

resource "openstack_compute_volume_attach_v2" "influxdb-va-new" {
  instance_id = openstack_compute_instance_v2.influxdb-usegalaxy-new.id
  volume_id   = openstack_blockstorage_volume_v3.influxdb-data-new.id
  device      = "/dev/vdb"
}

resource "aws_route53_record" "influxdb-usegalaxy-internal-new" {
  allow_overwrite = true
  zone_id         = var.zone_galaxyproject_eu
  name            = "influxdb.galaxyproject.eu"
  type            = "A"
  ttl             = "600"
  records         = ["${openstack_compute_instance_v2.influxdb-usegalaxy-new.access_ip_v4}"]
}
