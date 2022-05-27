data "openstack_images_image_v2" "simon-image" {
  name = "Ubuntu 20.04"
}

resource "openstack_compute_instance_v2" "simon" {
  name            = "Simon dedicated VM"
  flavor_name     = "m1.large"
  key_pair        = "cloud2"
  security_groups = ["default", "public-ssh"]

  network {
    name = "public"
  }

  block_device {
    uuid                  = data.openstack_images_image_v2.simon-image.id
    source_type           = "image"
    volume_size           = 100
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
     - "ssh-rsa ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAACAQCsmf+gD13h3SBxk81sV/sTXjrGTedRqGm7iM24f7XoGkP5GqBRjvls1v5NWWlztLoMWRusjW3p8+/aJSfgvO2K9seHm3ZYuzf7Q0Mp10IXN6TLyjNCkM67tez/E74KJHHxFYTnFUfnV6PcVPHP91HFFN++dSUvoDNL6QhR/uRtt++afz7l5WbmZ7VEOUa0J0/RhkHuegrbsbQXN+APtghicSlK9WVZh9yZfYCT5D/9Okl70hhlULT5sT4ouNMI8ktuiRe7fxMqZ6d2O7VK/e+nk/98PaqMFfQHODKipADBdfqoZiCD6GOz8AyRQUfDHT28g7ZovxUATUn9X6A99R2QYlpOdDAGCJhcrRKgzPt0KvO92+0MFGrLRkfUVifYoZIy8P4W2LWFMwi0Sp94iFXy9AXRwzJwfqT6d0EReGCgQrY9w2C2n+sKqpOfprdSy8ruV3x6ysLnOhhZm4QpXXiV3x25xzkFzIN6vscorQoVdHeFLJzifqVDnyLxHbfYkmGPacV7GV9sTIj3fe0Bb2bey4Vv7OXqZ3w744WhQvaYHg4d+lJBqNF7E4dt7Q9FS+rdFAeFJdRNCawYmGSkG0kxTw9oBChTFYoH+7rA1atPiNQvPJ5pCHmb5Q9q6GDjZyAjE2rtkgOAUldp28vlYW2qt+hEZSvK/SFqICU4wVl2rw=="
  EOF
}

