# 26.04.2024: Disabled as not needed anymore and the one from the old cloud is still running in the old cloud
# variable "workers-silver" {
#   default = 1
# }

# variable "workers-silver-volume-size" {
#   default = 200
# }

# resource "openstack_compute_instance_v2" "jenkins-workers-silver" {
#   name            = "worker-${count.index}.silver.build.galaxyproject.eu"
#   image_name      = var.jenkins_image
#   flavor_name     = "m1.xlarge"
#   key_pair        = "jenkins2"
#   security_groups = ["default"]
#   count           = var.workers-silver

#   network {
#     name = "bioinf"
#   }

#   user_data = <<-EOF
#     #cloud-config
#     bootcmd:
#         - test -z "$(blkid /dev/vdb)" && mkfs -t ext4 -L jenkins /dev/vdb
#         - mkdir -p /scratch
#     mounts:
#         - ["/dev/vdb", "/scratch", auto, "defaults,nofail", "0", "2"]
#     runcmd:
#         - [ chown, "centos.centos", -R, /scratch ]
#   EOF
# }

# resource "openstack_blockstorage_volume_v2" "jenkins-workers-silver-volume" {
#   name        = "jenkins-workers-silver-volume"
#   description = "Data volume for Jenkins worker-${count.index}.silver.build.galaxyproject.eu"
#   volume_type = "default"
#   size        = var.workers-silver-volume-size
#   count       = var.workers-silver
# }

# resource "openstack_compute_volume_attach_v2" "jenkins-workers-silver-va" {
#   instance_id = element(openstack_compute_instance_v2.jenkins-workers-silver.*.id, count.index)
#   volume_id   = element(openstack_blockstorage_volume_v2.jenkins-workers-silver-volume.*.id, count.index)
#   count       = var.workers-silver
# }

# resource "aws_route53_record" "jenkins-workers-silver" {
#   allow_overwrite = true
#   zone_id         = aws_route53_zone.zone_galaxyproject_eu.zone_id
#   name            = "worker-${count.index}.silver.build.galaxyproject.eu"
#   type            = "A"
#   ttl             = "7200"
#   records         = ["${element(openstack_compute_instance_v2.jenkins-workers-silver.*.access_ip_v4, count.index)}"]
#   count           = var.workers-silver
# }
