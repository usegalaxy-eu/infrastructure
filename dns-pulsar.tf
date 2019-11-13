resource "aws_route53_record" "freiburg-pulsar" {
  zone_id = "${var.zone_galaxyproject_eu}"
  name    = "de01.pulsar.galaxyproject.eu"
  type    = "A"
  ttl     = "7200"
  records = ["192.52.33.118"]
}

resource "aws_route53_record" "tuebingen-pulsar" {
  zone_id = "${var.zone_galaxyproject_eu}"
  name    = "de02.pulsar.galaxyproject.eu"
  type    = "A"
  ttl     = "7200"
  records = ["193.196.20.125"]
}

resource "aws_route53_record" "bari-pulsar" {
  zone_id = "${var.zone_galaxyproject_eu}"
  name    = "it01.pulsar.galaxyproject.eu"
  type    = "A"
  ttl     = "7200"
  records = ["90.147.75.162"]
}

resource "aws_route53_record" "brussels-pulsar" {
  zone_id = "${var.zone_galaxyproject_eu}"
  name    = "be01.pulsar.galaxyproject.eu"
  type    = "A"
  ttl     = "7200"
  records = ["193.190.85.137"]
}

resource "aws_route53_record" "lisboa-pulsar" {
  zone_id = "${var.zone_galaxyproject_eu}"
  name    = "pt01.pulsar.galaxyproject.eu"
  type    = "A"
  ttl     = "7200"
  records = ["192.92.147.4"]
}

resource "aws_route53_record" "freiburg-pulsar-gpu" {
  zone_id = "${var.zone_galaxyproject_eu}"
  name    = "de03.pulsar.galaxyproject.eu"
  type    = "A"
  ttl     = "7200"
  records = ["192.52.34.167"]
}
