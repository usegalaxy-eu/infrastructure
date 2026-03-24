variable "celery-count" {
  default = 0
}

data "openstack_images_image_v2" "celery-image" {
  name = "Rocky 9.4"
}

resource "openstack_compute_instance_v2" "celery" {
  name            = "celery-cloud-${count.index}.galaxyproject.eu"
  flavor_name     = "m1.xxlarge"
  key_pair        = "cloud2"
  tags            = []
  security_groups = ["default", "ingress-from-proxy"]

  network {
    name = "bioinf"
  }

  user_data = <<-EOF
    #cloud-config
    package_update: true
    package_upgrade: true
  EOF

  block_device {
    uuid                  = data.openstack_images_image_v2.celery-image.id
    source_type           = "image"
    destination_type      = "volume"
    boot_index            = 0
    volume_size           = 35
    delete_on_termination = true
  }

  count = var.celery-count
}

resource "aws_route53_record" "celery-cloud-galaxyproject" {
  allow_overwrite = true
  zone_id         = var.zone_galaxyproject_eu
  name            = "celery-cloud-${count.index}.galaxyproject.eu"
  type            = "A"
  ttl             = "600"
  records         = ["${element(openstack_compute_instance_v2.celery.*.access_ip_v4, count.index)}"]
  count           = var.celery-count
}
