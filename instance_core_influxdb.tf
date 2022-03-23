resource "openstack_compute_instance_v2" "influxdb-usegalaxy" {
  name            = "influxdb.galaxyproject.eu"
  image_name      = "generic-rockylinux8-v60-j168-5333625af7b2-main"
  flavor_name     = "m1.xlarge"
  key_pair        = "cloud2"
  security_groups = ["egress", "public-ssh", "public-ping", "public-influxdb", "public-web2",]

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

resource "openstack_blockstorage_volume_v2" "influxdb-data" {
  name        = "influxdb"
  description = "Data volume for InfluxDB"
  size        = 100
}

resource "openstack_compute_volume_attach_v2" "influxdb-va" {
  instance_id = openstack_compute_instance_v2.influxdb-usegalaxy.id
  volume_id   = openstack_blockstorage_volume_v2.influxdb-data.id
}

resource "aws_route53_record" "influxdb-usegalaxy-internal" {
  allow_overwrite = true
  zone_id         = var.zone_galaxyproject_eu
  name            = "influxdb.galaxyproject.eu"
  type            = "A"
  ttl             = "600"
  records         = ["${openstack_compute_instance_v2.influxdb-usegalaxy.access_ip_v4}"]
}
