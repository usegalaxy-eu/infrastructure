variable "sn06" {
  default = "132.230.223.239"
}

resource "aws_route53_record" "usegalaxy-eu" {
  allow_overwrite = true
  zone_id         = var.zone_usegalaxy_eu
  name            = "usegalaxy.eu"
  type            = "A"
  ttl             = "7200"
  records         = ["${var.sn06}"]
}

resource "aws_route53_record" "galaxyproject-eu" {
  allow_overwrite = true
  zone_id         = var.zone_galaxyproject_eu
  name            = "galaxyproject.eu"
  type            = "A"
  ttl             = "7200"
  records         = ["${var.sn06}"]
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
    "earth-system.usegalaxy.eu"
  ]
}

resource "aws_route53_record" "subdomains" {
  allow_overwrite = true
  zone_id         = var.zone_usegalaxy_eu

  count = 39
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

resource "aws_route53_record" "sn05-galaxyproject" {
  allow_overwrite = true
  zone_id         = var.zone_galaxyproject_eu
  name            = "sn05.galaxyproject.eu"
  type            = "A"
  ttl             = "7200"
  records         = ["10.5.68.4"]
}

resource "aws_route53_record" "cm-galaxyproject" {
  allow_overwrite = true
  zone_id         = var.zone_galaxyproject_eu
  name            = "condor-cm.galaxyproject.eu"
  type            = "CNAME"
  ttl             = "86400"
  records         = ["sn06.galaxyproject.eu"]
}

resource "aws_route53_record" "build-usegalaxy" {
  allow_overwrite = true
  zone_id         = var.zone_galaxyproject_eu
  name            = "build.galaxyproject.eu"
  type            = "A"
  ttl             = "7200"
  records         = ["132.230.223.230"]
}

## ZFS server #1 (all flash)
resource "aws_route53_record" "ssds1-galaxyproject" {
  zone_id = var.zone_galaxyproject_eu
  name    = "zfs0f.galaxyproject.eu"
  type    = "A"
  ttl     = "7200"
  records = ["10.5.68.239"]
}

## ZFS server #2 (spinning disks w/ flash cache)
resource "aws_route53_record" "zfs1-galaxyproject" {
  zone_id = var.zone_galaxyproject_eu
  name    = "zfs1.galaxyproject.eu"
  type    = "A"
  ttl     = "7200"
  records = ["10.5.68.238"]
}

## ZFS server #3 (all flash)
resource "aws_route53_record" "zfs2f-galaxyproject" {
  zone_id = var.zone_galaxyproject_eu
  name    = "zfs2f.galaxyproject.eu"
  type    = "A"
  ttl     = "7200"
  records = ["10.5.68.236"]
  #comment
}

## ZFS server #4 (all flash)
resource "aws_route53_record" "zfs3f-galaxyproject" {
  zone_id = var.zone_galaxyproject_eu
  name    = "zfs3f.galaxyproject.eu"
  type    = "A"
  ttl     = "7200"
  records = ["10.5.68.235"]
}

## Previous central-manager
#resource "aws_route53_record" "vgcn-cm" {
#  zone_id = "${var.zone_galaxyproject_eu}"
#  name    = "manager.vgcn.galaxyproject.eu"
#  type    = "A"
#  ttl     = "300"
#  records = ["10.5.68.230"]
#}


# VMs
resource "aws_route53_record" "plausible" {
  allow_overwrite = true
  zone_id         = var.zone_galaxyproject_eu
  name            = "plausible.galaxyproject.eu"
  type            = "A"
  ttl             = "600"
  records         = ["192.52.44.75"]
}

resource "aws_route53_record" "apollo-main" {
  allow_overwrite = true
  zone_id         = var.zone_galaxyproject_eu
  name            = "apollo.internal.galaxyproject.eu"
  type            = "A"
  ttl             = "600"
  records         = ["10.5.68.7"]
}

resource "aws_route53_record" "ftp" {
  allow_overwrite = true
  zone_id         = var.zone_usegalaxy_eu
  name            = "ftp.usegalaxy.eu"
  type            = "A"
  ttl             = "600"
  records         = ["132.230.223.213"]
}


## Interactive Tools
## We redirect all subdomains planning for URLs like
## https://727a121642ce1f94-3a20d7fa7b014959af58c7f6a47d1af.interactivetoolentrypoint.interactivetool.{some-subdomain}.usegalaxy.eu/
#resource "aws_route53_record" "it-subdomain-main-really" {
#  zone_id = var.zone_usegalaxy_eu
#
#  # Guess new domains won't get this for now, but whatever.
#  name    = "*.interactivetoolentrypoint.interactivetool.usegalaxy.eu"
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
    "earth-system.usegalaxy.eu"
  ]
}

resource "aws_route53_record" "it-subdomain-main" {
  allow_overwrite = true
  zone_id         = var.zone_usegalaxy_eu
  count           = 25
  name            = "*.interactivetoolentrypoint.interactivetool.${element(var.it-subdomain, count.index)}"
  type            = "CNAME"
  ttl             = "7200"
  records         = ["usegalaxy.eu"]
}

# SPF and DMARC records
resource "aws_route53_record" "usegalaxy_eu_dmarc_txt" {
  zone_id = var.zone_usegalaxy_eu
  name    = "_dmarc.usegalaxy.eu"
  type    = "TXT"
  ttl     = "300"
  records = [
    "v=DMARC1;p=reject;pct=100;ruf=mailto:galaxy-ops@informatik.uni-freiburg.de;aspf=r"
  ]
}

resource "aws_route53_record" "usegalaxy_eu_spf_txt" {
  zone_id = var.zone_usegalaxy_eu
  name    = ""
  type    = "TXT"
  ttl     = "300"
  records = [
    "v=spf1 include:mailgun.org -all"
  ]
}

resource "aws_route53_record" "galaxyproject_eu_dmarc_txt" {
  zone_id = var.zone_galaxyproject_eu
  name    = "_dmarc.galaxyproject.eu"
  type    = "TXT"
  ttl     = "300"
  records = [
    "v=DMARC1;p=reject;pct=100;ruf=mailto:galaxy-ops@informatik.uni-freiburg.de;aspf=r"
  ]
}

resource "aws_route53_record" "galaxyproject_eu_spf_txt" {
  zone_id = var.zone_galaxyproject_eu
  name    = ""
  type    = "TXT"
  ttl     = "300"
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
