# Apex domains must point at the IP address

variable "sn04" {
  default = "132.230.68.5"
}

resource "aws_route53_record" "usegalaxy-eu" {
  zone_id = "${var.zone_usegalaxy_eu}"
  name    = "usegalaxy.eu"
  type    = "A"
  ttl     = "7200"
  records = ["${var.sn04}"]
}

resource "aws_route53_record" "galaxyproject-eu" {
  zone_id = "${var.zone_galaxyproject_eu}"
  name    = "galaxyproject.eu"
  type    = "A"
  ttl     = "7200"
  records = ["${var.sn04}"]
}

# Subdomains are all just CNAMEs for galaxyproject.eu → proxy-external
variable "subdomain" {
  type = "list"

  default = [
    # Please place new subdomains at the end of the list
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
  ]
}

resource "aws_route53_record" "subdomains" {
  zone_id = "${var.zone_usegalaxy_eu}"

  count = 20
  name  = "${element(var.subdomain, count.index)}"

  type    = "CNAME"
  ttl     = "7200"
  records = ["usegalaxy.eu"]
}

# Subdomains for Project → proxy-external
variable "subdomain-project" {
  type = "list"

  default = [
    "status.galaxyproject.eu",
    "telescope.galaxyproject.eu",
  ]
}

resource "aws_route53_record" "subdomains-project" {
  zone_id = "${var.zone_galaxyproject_eu}"

  count = 2
  name  = "${element(var.subdomain-project, count.index)}"

  type    = "CNAME"
  ttl     = "7200"
  records = ["galaxyproject.eu"]
}

# Subdomains for Project → proxy-internal
variable "subdomain-internal" {
  type = "list"

  default = [
    # Please place new subdomains at the end of the list
    "cvmfs1-ufr0.galaxyproject.eu",
  ]
}

resource "aws_route53_record" "subdomain-internal" {
  zone_id = "${var.zone_galaxyproject_eu}"

  count = 1
  name  = "${element(var.subdomain-internal, count.index)}"

  type    = "CNAME"
  ttl     = "7200"
  records = ["proxy.internal.galaxyproject.eu"]
}

resource "aws_route53_record" "ftp" {
  zone_id = "${var.zone_usegalaxy_eu}"
  name    = "ftp.usegalaxy.eu"
  type    = "A"
  ttl     = "7200"
  records = ["132.230.68.85"]
}
