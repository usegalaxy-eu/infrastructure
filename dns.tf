resource "aws_route53_record" "usegalaxy-eu" {
  zone_id = "${var.zone_usegalaxy_eu}"
  name    = "usegalaxy.eu"
  type    = "A"
  ttl     = "300"
  records = ["192.52.3.222"]
}

resource "aws_route53_record" "apollo-usegalaxy-eu" {
  zone_id = "${var.zone_usegalaxy_eu}"
  name    = "apollo.usegalaxy.eu"
  type    = "CNAME"
  ttl     = "300"
  records = ["proxy.usegalaxy.eu"]
}

resource "aws_route53_record" "build-usegalaxy-eu" {
  zone_id = "${var.zone_usegalaxy_eu}"
  name    = "build.usegalaxy.eu"
  type    = "CNAME"
  ttl     = "300"
  records = ["proxy.usegalaxy.eu"]
}

resource "aws_route53_record" "ecology-usegalaxy-eu" {
  zone_id = "${var.zone_usegalaxy_eu}"
  name    = "ecology.usegalaxy.eu"
  type    = "CNAME"
  ttl     = "300"
  records = ["proxy.usegalaxy.eu"]
}

resource "aws_route53_record" "hic-usegalaxy-eu" {
  zone_id = "${var.zone_usegalaxy_eu}"
  name    = "hicexplorer.usegalaxy.eu"
  type    = "CNAME"
  ttl     = "300"
  records = ["proxy.usegalaxy.eu"]
}

resource "aws_route53_record" "metaegenomics-usegalaxy-eu" {
  zone_id = "${var.zone_usegalaxy_eu}"
  name    = "metagenomics.usegalaxy.eu"
  type    = "CNAME"
  ttl     = "300"
  records = ["proxy.usegalaxy.eu"]
}

resource "aws_route53_record" "influxdb-usegalaxy-eu" {
  zone_id = "${var.zone_usegalaxy_eu}"
  name    = "influxdb.usegalaxy.eu"
  type    = "A"
  ttl     = "300"
  records = ["192.52.2.249"]
}

resource "aws_route53_record" "proxy-usegalaxy-eu" {
  zone_id = "${var.zone_usegalaxy_eu}"
  name    = "proxy.usegalaxy.eu"
  type    = "A"
  ttl     = "300"
  records = ["192.52.3.222"]
}

resource "aws_route53_record" "rna-usegalaxy-eu" {
  zone_id = "${var.zone_usegalaxy_eu}"
  name    = "rna.usegalaxy.eu"
  type    = "CNAME"
  ttl     = "300"
  records = ["proxy.usegalaxy.eu"]
}

resource "aws_route53_record" "a-usegalaxy-eu" {
  zone_id = "${var.zone_usegalaxy_eu}"
  name    = "xn--2n8h.usegalaxy.eu"
  type    = "CNAME"
  ttl     = "300"
  records = ["proxy.usegalaxy.eu"]
}

resource "aws_route53_record" "b-usegalaxy-eu" {
  zone_id = "${var.zone_usegalaxy_eu}"
  name    = "xn--cw8h.usegalaxy.eu"
  type    = "CNAME"
  ttl     = "300"
  records = ["proxy.usegalaxy.eu"]
}

resource "aws_route53_record" "c-usegalaxy-eu" {
  zone_id = "${var.zone_usegalaxy_eu}"
  name    = "xn--ls8h.usegalaxy.eu"
  type    = "CNAME"
  ttl     = "300"
  records = ["proxy.usegalaxy.eu"]
}

resource "aws_route53_record" "stats-usegalaxy-eu" {
  zone_id = "${var.zone_usegalaxy_eu}"
  name    = "stats.usegalaxy.eu"
  type    = "A"
  ttl     = "300"
  records = ["192.52.3.121"]
}

resource "aws_route53_record" "sentry-usegalaxy-eu" {
  zone_id = "${var.zone_usegalaxy_eu}"
  name    = "sentry.usegalaxy.eu"
  type    = "A"
  ttl     = "300"
  records = ["192.52.2.56"]
}
