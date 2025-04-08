# variable "celery-count" {
#   default = 1
# }
#
# data "openstack_images_image_v2" "celery-image" {
#   name = "generic-rockylinux8-v60-j168-5333625af7b2-main"
# }
#
# resource "openstack_compute_instance_v2" "celery" {
#   name            = "celery-${count.index}.galaxyproject.eu"
#   image_id        = data.openstack_images_image_v2.celery-image.id
#   flavor_name     = "m1.xxlarge"
#   key_pair        = "cloud2"
#   tags            = []
#   security_groups = ["default", "ingress-from-proxy"]
#
#   network {
#     name = "bioinf"
#   }
#
#   user_data = <<-EOF
#     #cloud-config
#     package_update: true
#     package_upgrade: true
#   EOF
#
#   count = var.celery-count
# }

