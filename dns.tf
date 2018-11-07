# Apex domains must point at the IP address

resource "aws_route53_record" "usegalaxy-eu" {
  zone_id = "${var.zone_usegalaxy_eu}"
  name    = "usegalaxy.eu"
  type    = "A"
  ttl     = "7200"
  records = ["${openstack_compute_instance_v2.proxy.access_ip_v4}"]
}

resource "aws_route53_record" "proxy-usegalaxy-eu" {
  zone_id = "${var.zone_usegalaxy_eu}"
  name    = "proxy.usegalaxy.eu"
  type    = "CNAME"
  ttl     = "7200"
  records = ["proxy.galaxyproject.eu"]
}

resource "aws_route53_record" "usegalaxy-de" {
  zone_id = "${var.zone_usegalaxy_de}"
  name    = "usegalaxy.de"
  type    = "A"
  ttl     = "7200"
  records = ["${openstack_compute_instance_v2.proxy.access_ip_v4}"]
}

resource "aws_route53_record" "galaxyproject-eu" {
  zone_id = "${var.zone_galaxyproject_eu}"
  name    = "galaxyproject.eu"
  type    = "A"
  ttl     = "7200"
  records = ["${openstack_compute_instance_v2.proxy.access_ip_v4}"]
}

# Subdomains are all just CNAMEs for galaxyproject.eu
variable "subdomain" {
  type = "list"

  default = [
    "ecology.usegalaxy.eu",
    "hicexplorer.usegalaxy.eu",
    "metagenomics.usegalaxy.eu",
    "rna.usegalaxy.eu",
    "build.usegalaxy.eu",
    "stats.usegalaxy.eu",
    "beta.usegalaxy.eu",
    "proteomics.usegalaxy.eu",
    "clipseq.usegalaxy.eu",
    "test.usegalaxy.eu"
  ]
}

resource "aws_route53_record" "subdomains" {
  zone_id = "${var.zone_usegalaxy_eu}"

  count = ${length(var.subdomain)}
  name  = "${element(var.subdomain, count.index)}"

  type    = "CNAME"
  ttl     = "7200"
  records = ["proxy.galaxyproject.eu"]
}

# DEPRECATE
resource "aws_route53_record" "influxdb-usegalaxy-eu" {
  zone_id = "${var.zone_usegalaxy_eu}"
  name    = "influxdb.usegalaxy.eu"
  type    = "A"
  ttl     = "7200"
  records = ["192.52.2.249"]
}

resource "aws_route53_record" "sentry-usegalaxy-eu" {
  zone_id = "${var.zone_usegalaxy_eu}"
  name    = "sentry.usegalaxy.eu"
  type    = "A"
  ttl     = "7200"
  records = ["192.52.2.56"]
}
