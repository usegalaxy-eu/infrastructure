resource "openstack_compute_instance_v2" "build-usegalaxy" {
  name            = "build.galaxyproject.eu"
  image_name      = "${var.centos_image}"
  flavor_name     = "m1.large"
  key_pair        = "cloud2"
  security_groups = "${var.sg_webservice}"

  network {
    name = "public"
  }
}

resource "openstack_blockstorage_volume_v2" "build-data" {
  name        = "jenkins"
  description = "Data volume for Jenkins"
  size        = 50
}

resource "openstack_compute_volume_attach_v2" "jenkins-va" {
  instance_id = "${openstack_compute_instance_v2.build-usegalaxy.id}"
  volume_id   = "${openstack_blockstorage_volume_v2.build-data.id}"
}

resource "aws_route53_record" "build-usegalaxy" {
  zone_id = "${var.zone_galaxyproject_eu}"
  name    = "build.galaxyproject.eu"
  type    = "A"
  ttl     = "7200"
  records = ["132.230.223.230"]
}
