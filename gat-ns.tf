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

# Setup an IAM key
resource "aws_iam_access_key" "training-gxp-eu" {
  user    = "${aws_iam_user.training-gxp-eu.name}"
}

# And the user
resource "aws_iam_user" "training-gxp-eu" {
  name = "training.galaxyproject.eu"
  path = "/"
}

# And setup their policy
resource "aws_iam_user_policy" "training-subdomain-access" {
  name = "training-subdomain-access"
  user = "${aws_iam_user.training-gxp-eu.name}"

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
                "arn:aws:route53:::hostedzone/${aws_route53_zone.training-gxp-eu.zone_id}",
            ]
        }
    ]
}
EOF
}
