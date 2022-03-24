variable "sn06" {
  default = "132.230.223.239"
}

resource "aws_route53_record" "usegalaxy-eu" {
  zone_id = var.zone_usegalaxy_eu
  name    = "usegalaxy.eu"
  type    = "A"
  ttl     = "7200"
  records = ["${var.sn06}"]
}

resource "aws_route53_record" "galaxyproject-eu" {
  zone_id = var.zone_galaxyproject_eu
  name    = "galaxyproject.eu"
  type    = "A"
  ttl     = "7200"
  records = ["${var.sn06}"]
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
    "microgalaxy.usegalaxy.eu"
  ]
}

resource "aws_route53_record" "subdomains" {
  zone_id = var.zone_usegalaxy_eu

  count = 34
  name  = element(var.subdomain, count.index)

  type    = "CNAME"
  ttl     = "7200"
  records = ["usegalaxy.eu"]
}

resource "aws_route53_record" "sn06-galaxyproject" {
  zone_id = var.zone_galaxyproject_eu
  name    = "sn06.galaxyproject.eu"
  type    = "A"
  ttl     = "7200"
  records = ["${var.sn06}"]
}

resource "aws_route53_record" "sn05-galaxyproject" {
  zone_id = var.zone_galaxyproject_eu
  name    = "sn05.galaxyproject.eu"
  type    = "A"
  ttl     = "7200"
  records = ["10.5.68.4"]
}

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
