variable "gpu_node_beta_dns" {
  default = "gpu-node-beta.galaxyproject.eu"
}

resource "aws_route53_record" "gpunodebeta" {
  zone_id = "${var.zone_galaxyproject_eu}"
  name    = "${var.gpu_node_beta_dns}"
  type    = "A"
  ttl     = "600"
  records = ["132.230.223.54"]
}
