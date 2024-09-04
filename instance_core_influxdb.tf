resource "openstack_compute_instance_v2" "influxdb-usegalaxy" {
  name            = "influxdb.galaxyproject.eu"
  image_name      = "influxdb_15_04_2024"
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
    package_update: true
    package_upgrade: true
  EOF
}

# 17.4.2024: This resource creation is commented out because the volume
# from the old cloud is being attached to the instance in the new cloud.
# resource "openstack_blockstorage_volume_v3" "influxdb-data" {
#   name        = "influxdb"
#   description = "Data volume for InfluxDB"
#   size        = 100
# }

resource "openstack_compute_volume_attach_v2" "influxdb-va" {
  instance_id = openstack_compute_instance_v2.influxdb-usegalaxy.id
  volume_id   = "f6e77471-9180-4055-941f-b18fe353571c"
  device      = "/dev/vdb"
}

// resource "aws_route53_record" "influxdb-usegalaxy-internal" {
//   allow_overwrite = true
//   zone_id         = var.zone_galaxyproject_eu
//   name            = "influxdb.galaxyproject.eu"
//   type            = "A"
//   ttl             = "600"
//   records         = ["${openstack_compute_instance_v2.influxdb-usegalaxy.access_ip_v4}"]
// }
