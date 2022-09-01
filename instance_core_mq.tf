resource "openstack_compute_instance_v2" "mq-instance" {
  name            = "mq.galaxyproject.eu"
  image_name      = "generic-rockylinux8-v60-j167-5f3adb0e100c-main"
  flavor_name     = "m1.small"
  key_pair        = "cloud2"
  security_groups = ["egress", "public-ssh", "public-ping", "public-web2", "public-amqp"]

  network {
    name = "public"
  }
}
resource "aws_route53_record" "mq-instance" {
  zone_id = var.zone_galaxyproject_eu
  name    = "mq.galaxyproject.eu"
  type    = "A"
  ttl     = "600"
  records = ["${openstack_compute_instance_v2.mq-instance.access_ip_v4}"]
}
