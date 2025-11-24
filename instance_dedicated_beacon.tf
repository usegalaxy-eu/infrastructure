# Moved to KVM
#data "openstack_images_image_v2" "beacon-image" {
#  name = "vgcn~rockylinux-9-latest-x86_64~+generic+internal~20240820~42312~HEAD~479ec25"
#  most_recent = true
#}
#
#resource "openstack_compute_instance_v2" "beacon" {
#  name            = "beacon.galaxyproject.eu"
#  image_id        = data.openstack_images_image_v2.beacon-image.id
#  flavor_name     = "m1.small"
#  key_pair        = "cloud2"
#  tags            = []
#  security_groups = ["default", "public-web2"]
#
#  network {
#    name = "bioinf"
#  }
#
#  user_data = <<-EOF
#    #cloud-config
#    bootcmd:
#        - test -z "$(blkid /dev/vdb)" && mkfs -t ext4 /dev/vdb
#        - mkdir -p /data
#    mounts:
#        - ["/dev/vdb", "/data", auto, "defaults,nofail", "0", "2"]
#    runcmd:
#        - [ chown, "rocky.rocky", -R, /data ]
#    package_update: true
#    package_upgrade: true
#  EOF
#}
#
#resource "aws_route53_record" "beacon-galaxyproject" {
#  allow_overwrite = true
#  zone_id         = aws_route53_zone.zone_galaxyproject_eu.zone_id
#  name            = "beacon.galaxyproject.eu"
#  type            = "A"
#  ttl             = "600"
#  records         = ["${openstack_compute_instance_v2.beacon.access_ip_v4}"]
#}
#
#resource "random_id" "beacon-volume_name_unique" {
#  byte_length = 8
#}
#
#resource "openstack_blockstorage_volume_v3" "beacon-vol" {
#  name        = "beacon-data-vol-${random_id.beacon-volume_name_unique.hex}"
#  volume_type = "default"
#  description = "Data volume for beacon VM"
#  size        = 128
#}
#
#resource "openstack_compute_volume_attach_v2" "beacon-va" {
#  instance_id = openstack_compute_instance_v2.beacon.id
#  volume_id   = openstack_blockstorage_volume_v3.beacon-vol.id
#}
