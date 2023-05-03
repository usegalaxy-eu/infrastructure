data "openstack_images_image_v2" "gpu-node-tunc-image" {
  name = "vggp-gpu-v60-j310-1fad751e0150-main"
}

resource "openstack_compute_instance_v2" "gpu-node-tunc" {
  name            = "Tunc dedicated GPU VM"
  flavor_name     = "g1.c8m20g1"
  key_pair        = "cloud2"
  security_groups = ["default"]

  network {
    name = "public"
  }

  block_device {
    uuid                  = data.openstack_images_image_v2.gpu-node-tunc-image.id
    source_type           = "image"
    volume_size           = 50
    destination_type      = "volume"
    boot_index            = 0
    delete_on_termination = true
  }

  user_data = <<-EOF
    #cloud-config
    package_update: true
    package_upgrade: true
    packages:
    - cuda-11-6
    - nvidia-container-toolkit
    users:
     - default
    ssh_authorized_keys:
     - "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAACAQDGXjI2jLk+DgBFs0zxRX40+QPOo4WkC78LlHZWUvd9Iu1tae/dZSgNLn+Z+6+QSomRnElE0h4izIXbJ5JEfuGL5mZc8CsJOWezf7qnUpBi5B/aI89fGHhan/RqNqw+ZJdKBvIscm3viBzwDzWh6ovnF5HygBTKe2OD0WbSNPb3AF5klAKtiKqyHUtNlpmn26yJYWo84+Qd/x3uPUaE1DIu+jvK15Y9i0cWFnwvTplmRKw6ibnD4AWlDLJu4NqRdv+pGYzukWKiIs2csQdfyC6h9/0b8Eu+76BKaB41bAvJDgvP8xkb+tVat90XJYIyoiBeKUiZ7dCftMFdDv1KklyNyXDNe3rSHL0HJ559AUr7Va0/z2lAKgCWAzEpEe1tjVYi83299yU7hPvc7xvK44+S2D3kEDsspoB68GQzfo1zk+eL0L3aPxGR5Gr/mqcBLOmIRN1c4f3Y3JojhRoET+JDmcNRg/ewrA730OENtdRGwkebwCZLWRIM5kW6sxxTfd9NrsOWjGOsYHb/oFWd3KR3+mKoSjyffRMHu7f8qMWB6H4s8VvfdXhYMEQPrGMt5O/maiWBdE74L5eJSiPEGWrA8cOuexkirTrUJGn+5hTlAKXYQ/45AMjSgi90oxNbK9tyYcCFTFxZ954aQu4+hnJMJ4AdZRqaNxEPk6C9gB2dgw== tunc@BILP59"
  EOF
}
