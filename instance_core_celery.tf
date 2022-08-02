
variable "celery-count" {
  default = 1
}

data "openstack_images_image_v2" "celery-image" {
  name = "generic-rockylinux8-v60-j168-5333625af7b2-main"
}

resource "openstack_compute_instance_v2" "celery" {
  name            = "celery-${count.index}.galaxyproject.eu"
  image_id        = data.openstack_images_image_v2.celery-image.id
  flavor_name     = "c1.c36m100"
  key_pair        = "cloud2"
  security_groups = ["default"]

  network {
    name = "bioinf"
  }

  user_data = <<-EOF
    #cloud-config
    package_update: true
    package_upgrade: true
  EOF

  count = var.celery-count
}

resource "aws_route53_record" "celery-galaxyproject" {
  allow_overwrite = true
  zone_id         = var.zone_galaxyproject_eu
  name            = "celery-${count.index}.galaxyproject.eu"
  type            = "A"
  ttl             = "600"
  records         = ["${element(openstack_compute_instance_v2.celery.access_ip_v4, count.index)}"]
  count           = var.celery-count
}
