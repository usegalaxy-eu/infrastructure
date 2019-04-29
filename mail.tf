resource "aws_route53_record" "mx" {
  zone_id = "${var.zone_usegalaxy_eu}"
  name    = "usegalaxy.eu"
  type    = "MX"
  ttl     = "7200"
  records = ["10 mxa.mailgun.org", "10 mxb.mailgun.org"]
}

resource "aws_route53_record" "spf" {
  zone_id = "${var.zone_usegalaxy_eu}"
  name    = "usegalaxy.eu"
  type    = "TXT"
  ttl     = "7200"
  records = ["v=spf1 include:mailgun.org ~all"]
}

resource "aws_route53_record" "dkim" {
  zone_id = "${var.zone_usegalaxy_eu}"
  name    = "mailo._domainkey.usegalaxy.eu"
  type    = "TXT"
  ttl     = "7200"
  records = ["k=rsa; p=MIGfMA0GCSqGSIb3DQEBAQUAA4GNADCBiQKBgQDWqARw6lby+yJNifDd1Nf9FfegF2TB4VJAdupceZ6pAHwYvS/2WFUwc3ZxdA8+awjDfLr6cAWERnP6YsBqZ7/1jCvtvOM2RLvsKMrzKG+KycfSfaGfFLZw/qPHM+82Mz7o5PdmcVehDSjKrnRXWGjliF/bazOoPg4OJObmAlhovwIDAQAB"]
}
