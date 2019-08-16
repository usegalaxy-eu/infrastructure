variable "zone_galaxyproject_eu" {
  default = "Z386N8B8JBC6TQ"
}

variable "zone_usegalaxy_eu" {
  default = "Z1C7L7XFF9613J"
}

variable "netz_count" {
  default = 3
}

variable "netz" {
  description = "Internal networks"
  type        = "list"
  default     = ["192.52.32.0/20", "10.0.0.0/8", "132.230.0.0/16"]
}

variable "centos_image" {
  default = "generic-centos7-v31-j4-edc5aa3dc22c-master"
}

variable "centos_image_new" {
  default = "generic-centos7-v31-j18-2deef7cb2572-master"
}

variable "vgcn_image" {
  default = "vggp-v31-j101-2deef7cb2572-master"
}

variable "jenkins_image" {
  default = "jenkins-worker-j52-63ca7a6c7a15-master"
}

variable "sg_webservice" {
  type    = "list"
  default = ["egress", "ufr-ssh", "public-ping", "public-web2"]
}

variable "sg_webservice-pubssh" {
  type    = "list"
  default = ["egress", "public-ssh", "public-ping", "public-web2"]
}
