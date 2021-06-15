variable "coviddb-dns" {
  default = "coviddb.galaxyproject.eu"
}

resource "openstack_compute_instance_v2" "coviddb" {
  name            = "coviddb"
  image_name      = "CentOS 8"
  flavor_name     = "m1.medium"
  key_pair        = "cloud2"
  security_groups = ["default", "public-ssh", "public-web2"]

  network {
    name = "public"
  }

  user_data = <<-EOF
    #cloud-config
    package_update: true
    package_upgrade: true
    users:
     - default
       ssh_authorized_keys:
         - "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAACAQDBYETX45v81szULejgdthTXJSsITJ/qGx8vLyCJtf+zV98ZYPH18Z5JxzkEAYqtlsGIqIv/4jYtASPWCYE+n2XS7HCvdZjjHmBsp3/567qlTRkWI4mrlB242+8tj0ZLbbKSO0tdVALjIZEbXhYz8E7qyA8hZYKJ+ZxXkAgcS0FiquuWPFJLhXugxVJfGX96XOJey+Ww5iRmnUsVYSe8qgq8F0qMVFJ3FmnmvVY1smHmeTmEKd9lr3ZxwT+ke6Jke4ZAzhaIY+sfOngQQhAKvHtyDdNTS8WFmGsfJ8e2jzCUinqbnZEUK7MzIeDN+omTT3vziEQSNKVFYDothPpNQ8YsV5cCiXmGv/QnARGNHlA1vu52zpX0y6sx/zF/jP58LZxkC+a3R6x8iW/r8OKZPZJkw20FpNK5Urtb+bC1ErLBtsR+pb8lGGExIwSQ516r06l6IEIeJZODeTgMQN4oEmNTnrYGGw7B9K0Vi485424EMy/Uj73OfMlqcEtDdYIyYwzDW8eI6aVFjIRPwSjKrl0oFGnwdIdr4zoYEkf1uY5KIBC1gO6p9LQogQpIV4T6uZ5dOkG1akSvxX/4fXQklnDWM8UWUmpdn3otRr++K2tSjQGRwB2Z5z1g+oAadVVzklL+CmjsO5J83s98JDUlAB+pVUZiCDvn/8eRFgXNtuKJw=="
  EOF
}

resource "aws_route53_record" "coviddb" {
  zone_id = "${var.zone_galaxyproject_eu}"
  name    = "${var.coviddb-dns}"
  type    = "A"
  ttl     = "600"
  records = ["${openstack_compute_instance_v2.coviddb.access_ip_v4}"]
}