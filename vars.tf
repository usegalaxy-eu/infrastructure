variable "netz_count" {
  default = 3
}

variable "netz" {
  description = "Internal networks"
  type        = list(any)
  default     = ["192.52.32.0/20", "10.0.0.0/8", "132.230.0.0/16"]
}

variable "jenkins_image" {
  default = "jenkins-worker-v60-j105-d1dfcf46c4cd-main"
}
