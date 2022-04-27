resource "openstack_compute_instance_v2" "test-galaxy" {
  name            = "test.internal.usegalaxy.eu"
  flavor_name     = "m1.large"
  key_pair        = "cloud2"
  security_groups = ["egress", "public-web2", "ufr-ingress", "public-ping"]

  block_device {
    uuid                  = "594658a4-68c0-49ea-84bc-a973a6f5ffc7"
    source_type           = "image"
    volume_size           = 200
    boot_index            = 0
    destination_type      = "volume"
    delete_on_termination = true
  }

  network {
    name = "bioinf"
  }
}

resource "aws_route53_record" "test-galaxy" {
  zone_id = var.zone_usegalaxy_eu
  name    = "test.internal.usegalaxy.eu"
  type    = "A"
  ttl     = "600"
  records = ["${openstack_compute_instance_v2.test-galaxy.access_ip_v4}"]
}
