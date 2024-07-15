# 26.04.2024: Disabled; Need to be migrated
# resource "openstack_compute_instance_v2" "test-galaxy" {
#   name            = "test.internal.usegalaxy.eu"
#   flavor_name     = "m1.large"
#   key_pair        = "cloud2"
#   security_groups = ["egress", "public-web2", "ufr-ingress", "public-ping"]

#   block_device {
#     uuid                  = "878a687a-fe52-41eb-9012-45010314c790"
#     source_type           = "image"
#     volume_size           = 200
#     boot_index            = 0
#     destination_type      = "volume"
#     delete_on_termination = true
#   }

#   network {
#     name = "bioinf"
#   }
# }

# resource "aws_route53_record" "test-galaxy" {
#   allow_overwrite = true
#   zone_id         = var.zone_usegalaxy_eu
#   name            = "test.internal.usegalaxy.eu"
#   type            = "A"
#   ttl             = "300"
#   records         = ["10.5.68.154"]
# #  records         = ["${openstack_compute_instance_v2.test-galaxy.access_ip_v4}"]
# }
