variable "sn06" {
  default = "132.230.223.239"
}

variable "traefik" {
  default = "132.230.103.37"
}

resource "aws_route53_record" "usegalaxy-eu" {
  allow_overwrite = true
  zone_id         = var.zone_usegalaxy_eu
  name            = "usegalaxy.eu"
  type            = "A"
  ttl             = "7200"
  records         = ["${var.traefik}"]
}

resource "aws_route53_record" "galaxyproject-eu" {
  allow_overwrite = true
  zone_id         = var.zone_galaxyproject_eu
  name            = "galaxyproject.eu"
  type            = "A"
  ttl             = "7200"
  records         = ["${var.sn06}"]
}

resource "aws_route53_record" "beacon-galaxyproject" {
  allow_overwrite = true
  zone_id         = var.zone_galaxyproject_eu
  name            = "beacon.galaxyproject.eu"
  type            = "CNAME"
  ttl             = "600"
  records         = ["beacon.bi.privat"]
}

resource "aws_route53_record" "celery-galaxyproject" {
  allow_overwrite = true
  zone_id         = var.zone_galaxyproject_eu
  name            = "celery-1.galaxyproject.eu"
  type            = "A"
  ttl             = "600"
  records         = ["10.4.68.198"]
}

resource "aws_route53_record" "influxdb-proxy" {
  allow_overwrite = true
  zone_id         = var.zone_galaxyproject_eu
  name            = "influxdb.galaxyproject.eu"
  type            = "A"
  ttl             = "600"
  records         = ["${var.traefik}"]
}

resource "aws_route53_record" "mq-proxy" {
  allow_overwrite = true
  zone_id         = var.zone_galaxyproject_eu
  name            = "mq.galaxyproject.eu"
  type            = "A"
  ttl             = "600"
  records         = ["${var.traefik}"]
}

resource "aws_route53_record" "mq02-server" {
  allow_overwrite = true
  zone_id         = var.zone_galaxyproject_eu
  name            = "mq02.galaxyproject.eu"
  type            = "A"
  ttl             = "600"
  records         = ["10.4.68.197"]
}


resource "aws_route53_record" "tpv-broker" {
  allow_overwrite = true
  zone_id         = var.zone_galaxyproject_eu
  name            = "tpv-broker.galaxyproject.eu"
  type            = "A"
  ttl             = "600"
  records         = ["${var.traefik}"]
}

# Record for osiris-denbi.galaxyproject.eu
# redirected to from osiris.denbi.de
resource "aws_route53_record" "osiris-denbi" {
  allow_overwrite = true
  zone_id         = var.zone_galaxyproject_eu
  name            = "osiris-denbi.galaxyproject.eu"
  type            = "A"
  ttl             = "600"
  records         = ["${var.traefik}"]
}

# Subdomains are all just CNAMEs for galaxyproject.eu → proxy-external
variable "subdomain" {
  type = list(string)

  default = [
    # Please place new subdomains at the end of the list and increase the counter `count` below
    "ecology.usegalaxy.eu",
    "hicexplorer.usegalaxy.eu",
    "metagenomics.usegalaxy.eu",
    "rna.usegalaxy.eu",
    "build.usegalaxy.eu",
    "stats.usegalaxy.eu",
    "beta.usegalaxy.eu",
    "proteomics.usegalaxy.eu",
    "clipseq.usegalaxy.eu",
    "test.usegalaxy.eu",
    "old.usegalaxy.eu",
    "streetscience.usegalaxy.eu",
    "graphclust.usegalaxy.eu",
    "cheminformatics.usegalaxy.eu",
    "imaging.usegalaxy.eu",
    "singlecell.usegalaxy.eu",
    "climate.usegalaxy.eu",
    "nanopore.usegalaxy.eu",
    "metabolomics.usegalaxy.eu",
    "humancellatlas.usegalaxy.eu",
    "annotation.usegalaxy.eu",
    "erasmusmc.usegalaxy.eu",
    "live.usegalaxy.eu",
    "plants.usegalaxy.eu",
    "lite.usegalaxy.eu",
    "ml.usegalaxy.eu",
    "virology.usegalaxy.eu",
    "covid19.usegalaxy.eu",
    "africa.usegalaxy.eu",
    "microbiome.usegalaxy.eu",
    "cancer.usegalaxy.eu",
    "assembly.usegalaxy.eu",
    "india.usegalaxy.eu",
    "microgalaxy.usegalaxy.eu",
    "spatialomics.usegalaxy.eu",
    "materials.usegalaxy.eu",
    "phage.usegalaxy.eu",
    "aqua.usegalaxy.eu",
    "earth-system.usegalaxy.eu",
    "eirene.usegalaxy.eu",
    "microbiology.usegalaxy.eu",
    "astronomy.usegalaxy.eu"
  ]
}

resource "aws_route53_record" "subdomains" {
  allow_overwrite = true
  zone_id         = var.zone_usegalaxy_eu

  count = 42
  name  = element(var.subdomain, count.index)

  type    = "CNAME"
  ttl     = "7200"
  records = ["usegalaxy.eu"]
}

# Subdomains for Project redirected by the proxy to internal services
variable "subdomain-internal" {
  type = list(string)

  default = [
    # Please place new subdomains at the end of the list
    "cvmfs1-ufr0.galaxyproject.eu",
  ]
}

resource "aws_route53_record" "subdomain-internal" {
  allow_overwrite = true
  zone_id         = var.zone_galaxyproject_eu

  count = 1
  name  = element(var.subdomain-internal, count.index)

  type    = "CNAME"
  ttl     = "7200"
  records = ["proxy.galaxyproject.eu"]
}

# Bare metals
resource "aws_route53_record" "sn06-galaxyproject" {
  allow_overwrite = true
  zone_id         = var.zone_galaxyproject_eu
  name            = "sn06.galaxyproject.eu"
  type            = "A"
  ttl             = "7200"
  records         = ["${var.sn06}"]
}

resource "aws_route53_record" "sn07-galaxyproject" {
  allow_overwrite = true
  zone_id         = var.zone_galaxyproject_eu
  name            = "sn07.galaxyproject.eu"
  type            = "A"
  ttl             = "7200"
  records         = ["132.230.223.238"]
}

resource "aws_route53_record" "sn07-usegalaxy" {
  allow_overwrite = true
  zone_id         = var.zone_usegalaxy_eu
  name            = "sn07.usegalaxy.eu"
  type            = "A"
  ttl             = "7200"
  records         = ["132.230.223.238"]
}

resource "aws_route53_record" "sn05-galaxyproject" {
  allow_overwrite = true
  zone_id         = var.zone_galaxyproject_eu
  name            = "sn05.galaxyproject.eu"
  type            = "A"
  ttl             = "7200"
  records         = ["10.5.68.4"]
}

resource "aws_route53_record" "build-usegalaxy" {
  allow_overwrite = true
  zone_id         = var.zone_galaxyproject_eu
  name            = "build.galaxyproject.eu"
  type            = "A"
  ttl             = "7200"
  records         = ["132.230.223.230"]
}

resource "aws_route53_record" "cm-galaxyproject" {
  allow_overwrite = true
  zone_id         = var.zone_galaxyproject_eu
  name            = "cm.galaxyproject.eu"
  type            = "CNAME"
  ttl             = "7200"
  records         = ["build.galaxyproject.eu"]
}

resource "aws_route53_record" "sn09-galaxyproject" {
  allow_overwrite = true
  zone_id         = var.zone_galaxyproject_eu
  name            = "sn09.galaxyproject.eu"
  type            = "A"
  ttl             = "7200"
  records         = ["10.4.68.201"]
}

resource "aws_route53_record" "sn10-galaxyproject" {
  allow_overwrite = true
  zone_id         = var.zone_galaxyproject_eu
  name            = "sn10.galaxyproject.eu"
  type            = "A"
  ttl             = "7200"
  records         = ["10.4.68.202"]
}

resource "aws_route53_record" "sn11-galaxyproject" {
  allow_overwrite = true
  zone_id         = var.zone_galaxyproject_eu
  name            = "sn11.galaxyproject.eu"
  type            = "A"
  ttl             = "7200"
  records         = ["10.4.68.203"]
}

resource "aws_route53_record" "sn12-galaxyproject" {
  allow_overwrite = true
  zone_id         = var.zone_galaxyproject_eu
  name            = "sn12.galaxyproject.eu"
  type            = "A"
  ttl             = "7200"
  records         = ["10.4.68.204"]
}

## DNBD3 Boot Infrastructure
resource "aws_route53_record" "dnbd3-primary-galaxyproject" {
  allow_overwrite = true
  zone_id         = var.zone_galaxyproject_eu
  name            = "dnbd3-primary.galaxyproject.eu"
  type            = "A"
  ttl             = "7200"
  records         = ["10.8.103.38"]
}

resource "aws_route53_record" "dnbd3-proxy-galaxyproject" {
  allow_overwrite = true
  zone_id         = var.zone_galaxyproject_eu
  name            = "dnbd3-proxy.galaxyproject.eu"
  type            = "CNAME"
  ttl             = "7200"
  records         = ["sn12.bi.privat"]
}

## ZFS server #1 (all flash)
resource "aws_route53_record" "ssds1-galaxyproject" {
  allow_overwrite = true
  zone_id         = var.zone_galaxyproject_eu
  name            = "zfs0f.galaxyproject.eu"
  type            = "A"
  ttl             = "7200"
  records         = ["10.5.68.239"]
}

## ZFS server #2 (spinning disks w/ flash cache)
resource "aws_route53_record" "zfs1-galaxyproject" {
  allow_overwrite = true
  zone_id         = var.zone_galaxyproject_eu
  name            = "zfs1.galaxyproject.eu"
  type            = "A"
  ttl             = "7200"
  records         = ["10.5.68.238"]
}

## ZFS server #3 (all flash)
resource "aws_route53_record" "zfs2f-galaxyproject" {
  allow_overwrite = true
  zone_id         = var.zone_galaxyproject_eu
  name            = "zfs2f.galaxyproject.eu"
  type            = "A"
  ttl             = "7200"
  records         = ["10.5.68.236"]
  #comment
}

## ZFS server #4 (all flash)
resource "aws_route53_record" "zfs3f-galaxyproject" {
  allow_overwrite = true
  zone_id         = var.zone_galaxyproject_eu
  name            = "zfs3f.galaxyproject.eu"
  type            = "A"
  ttl             = "7200"
  records         = ["10.5.68.235"]
}

## Previous central-manager
#resource "aws_route53_record" "vgcn-cm" {
#  zone_id = "${var.zone_galaxyproject_eu}"
#  name    = "manager.vgcn.galaxyproject.eu"
#  type    = "A"
#  ttl     = "300"
#  records = ["10.5.68.230"]
#}

## Interactive Tools
## We redirect all subdomains planning for URLs like
## https://727a121642ce1f94-3a20d7fa7b014959af58c7f6a47d1af.interactivetoolentrypoint.interactivetool.{some-subdomain}.usegalaxy.eu/
#resource "aws_route53_record" "it-subdomain-main-really" {
#  zone_id = var.zone_usegalaxy_eu
#
#  # Guess new domains won't get this for now, but whatever.
#  name    = "*.ep.interactivetool.usegalaxy.eu"
#  type    = "CNAME"
#  ttl     = "7200"
#  records = ["usegalaxy.eu"]
#}
#

# If your subdomain needs GxIT privileges please place your subdomain at the end of the list and increase the counter `count` in the `it-subdomain-main` resource
variable "it-subdomain" {
  type = list(string)

  default = [
    "annotation.usegalaxy.eu",
    "aqua.usegalaxy.eu",
    "beta.usegalaxy.eu",
    "build.usegalaxy.eu",
    "cheminformatics.usegalaxy.eu",
    "climate.usegalaxy.eu",
    "clipseq.usegalaxy.eu",
    "ecology.usegalaxy.eu",
    "erasmusmc.usegalaxy.eu",
    "graphclust.usegalaxy.eu",
    "hicexplorer.usegalaxy.eu",
    "humancellatlas.usegalaxy.eu",
    "imaging.usegalaxy.eu",
    "usegalaxy.eu",
    "live.usegalaxy.eu",
    "metabolomics.usegalaxy.eu",
    "metagenomics.usegalaxy.eu",
    "nanopore.usegalaxy.eu",
    "proteomics.usegalaxy.eu",
    "rna.usegalaxy.eu",
    "singlecell.usegalaxy.eu",
    "stats.usegalaxy.eu",
    "streetscience.usegalaxy.eu",
    "test.usegalaxy.eu",
    "earth-system.usegalaxy.eu",
    "eirene.usegalaxy.eu"
  ]
}

resource "aws_route53_record" "it-subdomain-main" {
  allow_overwrite = true
  zone_id         = var.zone_usegalaxy_eu
  count           = 26
  name            = "*.ep.interactivetool.${element(var.it-subdomain, count.index)}"
  type            = "CNAME"
  ttl             = "7200"
  records         = ["usegalaxy.eu"]
}

resource "aws_route53_record" "usegalaxy_eu_mx_record" {
  allow_overwrite = true
  zone_id         = var.zone_usegalaxy_eu
  name            = ""
  type            = "MX"
  ttl             = 300
  records = [
    "10 mx1.forwardemail.net",
    "10 mx2.forwardemail.net"
  ]
}

resource "aws_route53_record" "usegalaxy_eu_mailforward_cname" {
  allow_overwrite = true
  zone_id         = var.zone_usegalaxy_eu
  name            = "fe-bounces.usegalaxy.eu"
  type            = "CNAME"
  ttl             = 300
  records = [
    "forwardemail.net"
  ]
}

# SPF and DMARC records
resource "aws_route53_record" "usegalaxy_eu_dmarc_txt" {
  allow_overwrite = true
  zone_id         = var.zone_usegalaxy_eu
  name            = "_dmarc.usegalaxy.eu"
  type            = "TXT"
  ttl             = "300"
  records = [
    "v=DMARC1; p=reject; pct=100; rua=mailto:dmarc-66c44965559d8b25a9140b95@forwardemail.net;"
  ]
}

resource "aws_route53_record" "usegalaxy_eu_forwardmail_validation_txt" {
  allow_overwrite = true
  zone_id         = var.zone_usegalaxy_eu
  name            = ""
  type            = "TXT"
  ttl             = "3600"
  records = [
    "forward-email-site-verification=XS8hOkR5lO",
    "v=spf1 a include:spf.forwardemail.net -all"
  ]
}

resource "aws_route53_record" "galaxyproject_eu_dmarc_txt" {
  allow_overwrite = true
  zone_id         = var.zone_galaxyproject_eu
  name            = "_dmarc.galaxyproject.eu"
  type            = "TXT"
  ttl             = "300"
  records = [
    "v=DMARC1;p=reject;pct=100;ruf=mailto:galaxy-ops@informatik.uni-freiburg.de;aspf=r"
  ]
}

resource "aws_route53_record" "galaxyproject_eu_spf_txt" {
  allow_overwrite = true
  zone_id         = var.zone_galaxyproject_eu
  name            = ""
  type            = "TXT"
  ttl             = "300"
  records = [
    "v=spf1 -all"
  ]
}

#
## https://727a121642ce1f94-3a20d7fa7b014959af58c7f6a47d1af.interactivetoolentrypoint.interactivetool.test.internal.usegalaxy.eu/
##resource "aws_route53_record" "it-subdomain-test" {
##zone_id = "${var.zone_usegalaxy_eu}"
##name    = "*.interactivetoolentrypoint.interactivetool.test.internal.usegalaxy.eu"
##type    = "CNAME"
##ttl     = "600"
##records = ["test.internal.usegalaxy.eu"]
##}
