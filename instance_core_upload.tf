variable "upload-dns" {
  default = "upload.galaxyproject.eu"
}

data "openstack_images_image_v2" "upload-image" {
  name = "generic-internal-v60-j333-fb0029b7a329-dev"
}

resource "openstack_compute_instance_v2" "upload" {
  name            = var.upload-dns
  image_id        = data.openstack_images_image_v2.upload-image.id
  flavor_name     = "m1.medium"
  key_pair        = "cloud2"
  security_groups = ["default", "public-ssh", "public-web2", "ufr-ingress"]

  network {
    name = "bioinf"
  }

  user_data = <<-EOF
    #cloud-config
    package_update: true
    package_upgrade: true
  EOF
}

resource "aws_route53_record" "upload-galaxyproject" {
  allow_overwrite = true
  zone_id         = var.zone_galaxyproject_eu
  name            = var.upload-dns
  type            = "A"
  ttl             = "600"
  records         = ["${openstack_compute_instance_v2.upload.access_ip_v4}"]
}
