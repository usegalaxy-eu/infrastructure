data "openstack_images_image_v2" "maintenance-image" {
  name = "generic-rockylinux8-v60-j167-5f3adb0e100c-main"
}

resource "openstack_compute_instance_v2" "maintenance" {
  name            = "maintenance.galaxyproject.eu"
  flavor_name     = "m1.xlarge"
  key_pair        = "cloud2"
  tags            = []
  security_groups = ["default", "rsyslog", "htcondor_shared_port"]

  network {
    name = "bioinf"
  }

  block_device {
    uuid                  = data.openstack_images_image_v2.maintenance-image.id
    source_type           = "image"
    volume_size           = 500
    destination_type      = "volume"
    boot_index            = 0
    delete_on_termination = true
  }

  user_data = <<-EOF
    #cloud-config
    package_update: true
    package_upgrade: true
  EOF
}

resource "aws_route53_record" "maintenance-galaxyproject" {
  allow_overwrite = true
  zone_id         = var.zone_galaxyproject_eu
  name            = "maintenance.galaxyproject.eu"
  type            = "A"
  ttl             = "600"
  records         = ["${openstack_compute_instance_v2.maintenance.access_ip_v4}"]
}
