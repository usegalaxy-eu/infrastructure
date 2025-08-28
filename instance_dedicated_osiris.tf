resource "openstack_compute_instance_v2" "osiris-denbi" {
  name            = "osiris-denbi.galaxyproject.eu"
  image_name      = "Rocky 9"  # Assuming this matches de.NBI cloud image 361fa0da-86b0-48bf-840b-e79f7723b4a3
  flavor_name     = "m1.large"
  key_pair        = "cloud2"
  security_groups = ["egress", "public-web2", "default", "public-ping"]

  network {
    name = "public"
  }
}

# For DNS record see dns.tf and osiris-denbi.galaxyproject.eu
