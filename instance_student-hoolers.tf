variable "student-hollers-dns" {
  default = "student-hollers-vm"
}

data "openstack_images_image_v2" "student-hollers-image" {
  name = "Ubuntu 20.04"
}

resource "openstack_compute_instance_v2" "student-hollers" {
  name        = "${var.student-hollers-dns}"
  flavor_name = "m1.xxlarge"
  key_pair    = "cloud2"
  security_groups = ["default", "public-ssh", "public-web2"]

  network {
    name = "public"
  }

  block_device {
    uuid                  = "${data.openstack_images_image_v2.student-hollers-image.id}"
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
    users:
     - default
    ssh_authorized_keys:
     - "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABgQDC6IJZr895Q4tO5HNmaARdcy70gY7+FHoBL2rHuYV++VMks3Q5RjPKjQqR/1malPBQR0suPwPp8mFV37Q1pkgnznEeAE8onkeUOybzcMKsaH7HiQxgN2Ic/+74HHHm/pkraN7zs0LzUDC6aVFSI0mh0aa/N/Qvyh+szE5Z4fHeQPdP1edkPmtI1M54achSR5b2tNCmjoQnkGmlRssXI97I2PPpy5hdjeXGaPg10SpYuz4Tpr0doZK2QhpVFeg8PrJ/bzCr0Bl4Mb/M5ItKUVJFn89XIe55xkgJRfw6gaVGiPK+VUUDmtvK3D39AS/0hBQ1AOVWDKl9lYgsSJikrLGbe81QsRMIpiNKDCy25eAH/OgtTHf3e0lg8qde0HDSwpTmUR2DuNr14999WbMQLMyplA6Tx4oAefvTtzrBRRZR5UOaIrT80vEzJwo+Mx5SLGT2A++nuGPZW0FZqO4rLmylqTIGngRxp14w0AIUZUhnQdxmQZlkBUeggK7igAVDjFs= sebastian@LAPTOP-8S2B40ST"
     - "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAACAQCxTSveJ+aXoyf7/B8pQicZLQjeBmJYJBY4FlAIIDYNE2I8RUvGEL0hrgjs1ZVUrMbioGMARkAbxuIlWpagLqShA5rguyLHYl9WaTNOIrs8swwQnnDU7SFvPhpdEIEY9g9jKNya9MAejQRHaIjw2jcawTlOEMiC7sNYZ/+/z/m19Iz+ssA1jDsUGIIYKX8Aw2OAIijGqOLe1KV/sIc4QRtpyFiqgxUKyrV2/nFwgBD/z9+kIZmW+uMdn3smQiQ/KjWmaEiALM/a02NLc9JWeju8UEtW+Dm/0LH3z0Q9thOIN7DZ6vZBHGhzLmaB5bRWncXraoNWVye2bNqktzjTs02Tr7M+GajVs0xOjfaZFNmCC/aGESFhPd5T7DgOpW5rAntS22RJQVRMK8v7n+R02V6YmsGnfjzv/EAOljTkMdBss81jbRcnPDp2G3nQjrElQxjU1z2sBCa0VkGO5C+oB3uz7iC2vcOLxVl+/2NbxQ0FCLrwafWo+pVrdvKhaqP8jS02P3aXTF+ES9OYYP/hXYo8uJ2416R7iBAB7wyaR/CLNCCl6OeBOiA6lYcXkAQEoNQfRGGFvLCa4i5Wlj2d6CZBNKoxv6s/8SwYNx2m6lslS9B1bMDBAKAn6DZH9UI3o/kD/mHL0pfgmwFfrJDsDRxTGdUcxdXMKleQlMo5fwvgrw== wm75"
  EOF
}
