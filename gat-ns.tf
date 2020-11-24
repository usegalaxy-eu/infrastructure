data "aws_route53_zone" "gxp-eu" {
  name         = "galaxyproject.eu."
}

resource "aws_route53_zone" "training-gxp-eu" {
  name = "training.galaxyproject.eu"
}

#resource "aws_route53_record" "ns-training-gxp-eu" {
  #zone_id = "${aws_route53_zone.gxp-eu.zone_id}"
  #name    = "training.galaxyproject.eu"
  #type    = "NS"
  #ttl     = "3600"
  #records = "${aws_route53_zone.training-gxp-eu.name_servers}"
#}
