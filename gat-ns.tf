data "aws_route53_zone" "gxp-eu" {
  zone_id = "${var.zone_galaxyproject_eu}"
}

# Setup the hosted zone below
resource "aws_route53_zone" "training-gxp-eu" {
  name = "training.galaxyproject.eu"
}

# It needs its own set of NS
resource "aws_route53_record" "ns-training-gxp-eu" {
  zone_id = "${data.aws_route53_zone.gxp-eu.zone_id}"
  name    = "training.galaxyproject.eu"
  type    = "NS"
  ttl     = "3600"
  records = ["${aws_route53_zone.training-gxp-eu.name_servers}"]
}

variable "count-iam-tokens" {
  default = 2
}

# Setup an IAM key
resource "aws_iam_access_key" "training-gxp-eu" {
  user  = "${element(aws_iam_user.training-gxp-eu.*.name, count.index)}"
  count = "${var.count-iam-tokens}"
}

# Output
output "gat-iam-key-access" {
  value     = ["${aws_iam_access_key.training-gxp-eu.*.id}"]
  sensitive = true
}

output "gat-iam-key-secret" {
  value     = ["${aws_iam_access_key.training-gxp-eu.*.secret}"]
  sensitive = true
}

# And the user
resource "aws_iam_user" "training-gxp-eu" {
  name  = "training.galaxyproject.eu@${count.index}"
  path  = "/"
  count = "${var.count-iam-tokens}"
}

# And setup their policy
resource "aws_iam_policy" "training-subdomain-access" {
  name        = "training-subdomain-access"
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
                "arn:aws:route53:::hostedzone/${aws_route53_zone.training-gxp-eu.zone_id}"
            ]
        }
    ]
}
EOF
}

# Attach policy to user
resource "aws_iam_user_policy_attachment" "training-subdomain-access-gxp-eu" {
  user       = "${element(aws_iam_user.training-gxp-eu.*.name, count.index)}"
  policy_arn = "${aws_iam_policy.training-subdomain-access.arn}"
  count      = "${var.count-iam-tokens}"
}
