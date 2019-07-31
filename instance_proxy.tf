resource "openstack_compute_instance_v2" "proxy-internal" {
  name            = "proxy.internal.galaxyproject.eu"
  image_name      = "${var.centos_image}"
  flavor_name     = "m1.small"
  key_pair        = "cloud2"
  security_groups = ["egress", "public-ssh", "public-ping", "public-web2", "public-amqp"]

  network {
    name = "public-extended"
  }
  
  user_data = <<-EOF
    #cloud-config
    ssh_authorized_keys:
      - ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAACAQC1NsmuU6ETRGMk1veC5jyx/bRZ3WTjgoxVUcWAFizpvPGWdJc2x0ZW0dMr9WDSlqXkQHf4FvRiqxtL9Q8Kej8odESM7ej6y1/huGfQTGtHnCOV2P4MC+nNaNim0KzEUwgQ9MNdMUnfhJcmRNHIIUVFtxEfC2bhthoBpEN6WMehRgn7E91e9W5GHA7nmHmQCDTFGkPGyM3FTPsEarH9P4hjXlfp9pRb/vlhm5xbHEgKZU1iIDrNDZNeMfZlK7Ja1u9rCzAavwzNkwcLt3/dMoXuiDXTFtlzTM83bseHseCLpczJuwhW62DtitX4K/dO6zCKmcv1EUt2SEY2PsnZ0sZypDCtYq+lsCTUukp8E/DPzSsd61vfHEZBMzRw7bxU7ELH/TlcTRs4UmAYXA7phkmetIVq2Y9vNni1UP04dwP9rvlqdYXNDemIMs4AC48SDnrhZ47zSP0S6EMvKhcZcSWhAKKMr0p+3OHrifNXhLcLoz/+lsM1z/ev1YYeigkyXjVYeWGLy8fYSG5yEp27mSWdde1frGnp4Bl0t9FemcBI+AKvugwZiHNlUVI3m3XyP6tygK+MdMPQp6NwNWHKYUPFRZvRSnOEOoj6B9RRUEzW9XWR8Np1iuAf76UtuW4r/nwKlKKwU/uF7oKaRuiIUAYzGdyQrcZuBp3l4vV7h7bptw== gmauro@informatik.uni-freiburg.de
  EOF
}

resource "aws_route53_record" "proxy-internal" {
  zone_id = "${var.zone_galaxyproject_eu}"
  name    = "proxy.internal.galaxyproject.eu"
  type    = "A"
  ttl     = "7200"
  records = ["${openstack_compute_instance_v2.proxy-internal.access_ip_v4}"]
}

resource "aws_route53_record" "proxy" {
  zone_id = "${var.zone_galaxyproject_eu}"
  name    = "proxy.galaxyproject.eu"
  type    = "A"
  ttl     = "300"
  records = ["${openstack_compute_instance_v2.proxy-internal.access_ip_v4}"]
}
