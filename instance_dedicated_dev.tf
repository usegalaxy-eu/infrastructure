# 26.04.2024: Disabled; User VMs are still in the old cloud and they are informed to take backups of all of their data
# and then we will recreate the new VMs in the new cloud.
# data "openstack_images_image_v2" "dev-image" {
#   name = "Ubuntu 20.04"
# }

# resource "openstack_compute_instance_v2" "dev" {
#   name            = "Dedicated development VM"
#   flavor_name     = "m1.xlarge"
#   key_pair        = "cloud2"
#   security_groups = ["default", "public-ssh", "public-web2"]

#   network {
#     name = "public"
#   }

#   block_device {
#     uuid                  = data.openstack_images_image_v2.dev-image.id
#     source_type           = "image"
#     volume_size           = 500
#     destination_type      = "volume"
#     boot_index            = 0
#     delete_on_termination = true
#   }

#   user_data = <<-EOF
#     #cloud-config
#     package_update: true
#     package_upgrade: true
#     users:
#      - default
#     ssh_authorized_keys:
#      - https://github.com/bgruening.keys
#      - "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAACAQCoWkk57x20iE5Wf0cDX3QvkJf/XxO4wqIeZIPIosK7rFcvy/SvDF/mwQk4iQrQ7qDam35NFHrFden+5zoE5HJoRVeHYhqNaItmiMNBY9CqgITCXsD2j9/6NdzIcR66uzLHDVvLlXr2hJmrNoeGTzg94+EVtQ0/BARwffAq//2WzgG4oClgYE4RqahQRXbmBygf4g4BAbEb5JnsLJ3qqnhsAgcUYyXg7/dz36QVsvoTwChMMCXDJpPyNb1+PqOKAgl7+yZQiPD0yI5zZG+iF6dsvc6Dhscpmt0nOjr4h+o97wQk3sbvq9ysXPlARqgL950H+0LtSiWnC+KEBK4KOgc83g6NynCE7zGZ9LJiKoT0mmt8BKaJKFRDVob3nlYR3/DDLEq2AkCoxYF0JFUNVta/wEF/likB61Yhsv01gNVMNcCfK9nzZVyTGNwdsFPdi4WL+KfkMgEcA0xrCtLXhkxnU8f3H8a7XcwJWr3fuSK1ndFwNxmfKlA+sRRKYBHouU8rpnC/HCxYsxF/palYxHv8KNcfGIRUBIgfgugsigzFcB5yz4lY73NiEyVEY9ZnBbbXllyX3ICoI/IboMQVUDyccRZiDAeHJ/v29pIsIihkmWIT2I1VqppXuVYgTydPM42CDBaKE7ko3p0CuZDyB2sZaS4XYUQlkRpX9ZARtcC/AQ== david"
#      - "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABgQDL73+WfMW9nom0BtLfPOiDPh9z/t0ZcISLXgW1rUCZe3uXD1QluFJXZeFdBW5Gs8+WaBfBYZyEXrxsPH9CcEIHzNvvdYqh2YDwnEWTbpBahSXSJFOUHU96iRNVq+RpHZMQp70Ib/E0tLeS0sCP1OPlI4SXk7MUwWWAaRB/LCSNsZUqyGNtMlgNwFcefVydwDMEnB1WQeyOAQXOjw7MVlpKEv4ODcHznqzOlqm+LYoYzq5CLkRD8SL1esHUCbrDdZTYu2aO07rkjlRthqZc/xIN89yudn7cDH5ip1bu7N6bzEly0Q/PLLMYp7Aow2vA3Gntjg5M2AL97HUu2Usaj5EW1IGP4sGdH/FY/Nd7HVwpySuHcTQTyrC6+O1z0kXyeF/lWovJa451YcUj4Zh4rsFLtn75T+uwa14jqneSOdnvtP0zMQXhpXxHeEYmpWUUpet3R5B9qjyEnMI4PsxTxw4Qj+KF0C8JwnsHV3MnP7pOBC3+nj5+88th7zwWMziUeMk= alireza@alireza-aluf"
#   EOF
# }

