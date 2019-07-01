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


start = 180
for idx, row in enumerate(sys.stdin):
    row = row.strip()
    sys.stderr.write("gcc-%s.training.galaxyproject.eu\n" % (start + idx))
    sys.stdout.write(tpl % (start + idx, start + idx, row))
