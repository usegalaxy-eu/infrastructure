resource "openstack_compute_instance_v2" "telescope" {
  name            = "telescope.galaxyproject.eu"
  image_name      = "${var.centos_image}"
  flavor_name     = "m1.tiny"
  key_pair        = "cloud2"
  security_groups = "${var.sg_webservice}"

  network {
    name = "public"
  }
}

resource "openstack_blockstorage_volume_v2" "telescope-data" {
  name        = "telescope"
  description = "Data volume for GRT"
  size        = 200
}

resource "openstack_compute_volume_attach_v2" "telescope-va" {
  instance_id = "${openstack_compute_instance_v2.telescope.id}"
  volume_id   = "${openstack_blockstorage_volume_v2.telescope-data.id}"
}

resource "aws_route53_record" "telescope" {
  zone_id = "${var.zone_galaxyproject_eu}"
  name    = "${openstack_compute_instance_v2.telescope.name}"
  type    = "A"
  ttl     = "7200"
  records = ["${openstack_compute_instance_v2.telescope.access_ip_v4}"]
}
