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

# Record for osiris-denbi.galaxyproject.eu
# redirected to from osiris.denbi.de
resource "aws_route53_record" "osiris-denbi-galaxyproject" {
  allow_overwrite = true
  zone_id         = var.zone_galaxyproject_eu
  name            = "osiris-denbi.galaxyproject.eu"
  type            = "A"
  ttl             = "600"
  records         = ["${openstack_compute_instance_v2.incoming.access_ip_v4}"]
}

resource "aws_route53_record" "osiris-denbi" {
  allow_overwrite = true
  zone_id         = var.zone_galaxyproject_eu
  name            = "osiris.denbi.de"
  type            = "A"
  ttl             = "600"
  records         = ["${openstack_compute_instance_v2.incoming.access_ip_v4}"]
}
