resource "aws_route53_record" "ns_training_galaxyproject_eu" {
  zone_id = aws_route53_zone.zone_gat_eu.zone_id
  name    = "training.galaxyproject.eu"
  type    = "NS"
  ttl     = "3600"
  records = "${aws_route53_zone.zone_gat_eu.name_servers}"
}

variable "gat_count_iam_tokens" {
  default = 28
}

resource "aws_iam_access_key" "training_galaxyproject_eu" {
  user    = element(aws_iam_user.training_galaxyproject_eu.*.name, count.index)
  count   = var.gat_count_iam_tokens
}

output "gat_iam_key_access" {
  value     = ["${aws_iam_access_key.training_galaxyproject_eu.*.id}"]
  sensitive = true
}

output "gat_iam_key_secret" {
  value     = ["${aws_iam_access_key.training_galaxyproject_eu.*.encrypted_secret}"]
  sensitive = true
}

resource "aws_iam_user" "training_galaxyproject_eu" {
  name  = "training.galaxyproject.eu@${count.index}"
  path  = "/"
  count = var.gat_count_iam_tokens
}

resource "aws_iam_policy" "gat_subdomain_access" {
  name        = "gat-subdomain-access"
  path        = "/"
  description = "Permit training keys to access the training.galaxyproject.eu subdomain"

  policy = <<EOF
{
    "Version": "2012-10-17",
    "Statement": [
        {
            "Effect": "Allow",
            "Action": [
                "route53:ListHostedZones",
                "route53:GetChange"
            ],
            "Resource": [
                "*"
            ]
        },
        {
            "Effect": "Allow",
            "Action": [
                "route53:ChangeResourceRecordSets"
            ],
            "Resource": [
                "arn:aws:route53:::hostedzone/${aws_route53_zone.zone_gat_eu.zone_id}"
            ]
        }
    ]
}
EOF
}

resource "aws_iam_user_policy_attachment" "training-subdomain-access-gxp-eu" {
  user       = element(aws_iam_user.training_galaxyproject_eu.*.name, count.index)
  policy_arn = aws_iam_policy.gat_subdomain_access.arn
  count      = var.gat_count_iam_tokens
}
