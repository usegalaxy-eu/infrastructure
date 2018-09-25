resource "openstack_compute_instance_v2" "hicbrowser" {
  name            = "HiCBrowser AG Hein II"
  image_name      = "${var.centos_image}"
  flavor_name     = "m1.xxlarge"
  key_pair        = "cloud2"
  security_groups = "${var.sg_webservice}"

  network {
    name = "public"
  }
}

resource "openstack_blockstorage_volume_v2" "hicbrowser-data" {
  name        = "hicbrowser"
  description = "Data volume for hicbrowser"
  size        = 10
}

resource "openstack_compute_volume_attach_v2" "hicbrowser-va" {
  instance_id = "${openstack_compute_instance_v2.hicbrowser.id}"
  volume_id   = "${openstack_blockstorage_volume_v2.hicbrowser-data.id}"
}

#resource "aws_route53_record" "hicbrowser" {
#zone_id = "${var.zone_galaxyproject_eu}"
#name    = "hicbrowser.galaxyproject.eu"
#type    = "A"
#ttl     = "300"
#records = ["${openstack_compute_instance_v2.hicbrowser.access_ip_v4}"]
#}

