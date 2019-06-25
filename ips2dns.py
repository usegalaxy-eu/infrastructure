import sys

tpl = """
resource "aws_route53_record" "gcc-%s-training-galaxyproject-eu" {
  zone_id = "${var.zone_galaxyproject_eu}"
  name    = "gcc-%s.training.galaxyproject.eu"
  type    = "A"
  ttl     = "7200"
  records = ["%s"]
}
"""


start = 75
for idx, row in enumerate(sys.stdin):
    row = row.strip()
    print "gcc-%s.training.galaxyproject.eu" % (start + idx)
    # print(tpl % (start + idx, start + idx, row))
