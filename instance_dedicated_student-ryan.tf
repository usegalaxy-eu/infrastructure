data "openstack_images_image_v2" "ryan-image" {
  name = "Ubuntu 22.04"
}

resource "openstack_compute_instance_v2" "ryan" {
  name            = "student-ryan-vm"
  flavor_name     = "c1.c36m100"
  key_pair        = "cloud2"
  security_groups = ["default", "public-ssh"]

  network {
    name = "public"
  }

  block_device {
    uuid                  = data.openstack_images_image_v2.ryan-image.id
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
     - "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABAQDBcpda672t3wf3+PC4eE6msq2ekuco5QAnAoNwHBYGwWSOY+iNTZecEDsFGaVwnprljGoprq8YXmtlSl1EZAr9eloQWvyd7ouzb116rcldyfgF+Ud/ldBXRCIRK4Rw5Xwjorn3lLmgc1g6hRdHqUDoQAjgAlXCo9Ze4pPeGOvk1QeNF4APH1N5ZP3ipBo5IXVx32rcNgRttexGSqr14W333k16LDlJboGbRkej9PmJHyP8kDrTpXQZSsJ0xgEMTUBKTy4Y+z3QLeQ+dA6D79V8t3+xsi+gPAVq871L7W5Q+CBisdcCUb5ss3yOwq2aAf2U0uxHmI5DkT4HNxnJ6gJR ivelet@Ryans-MacBook-Pro.local"
  EOF
}
