import sys

tpl = """resource "aws_route53_record" "%s" {
  zone_id = "${var.zone_galaxyproject_eu}"
  name    = "%s"
  type    = "A"
  ttl     = "7200"
  records = ["%s"]
}
"""


for (dns, ip) in [x.split('\t') for x in sys.stdin.read().strip().split('\n')]:
    dotless = dns.replace('.', '-')
    print(tpl % (dotless, dns, ip))

