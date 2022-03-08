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
  type        = list(any)
  default     = ["192.52.32.0/20", "10.0.0.0/8", "132.230.0.0/16"]
}

variable "jenkins_image" {
  default = "jenkins-worker-v60-j66-5f3adb0e100c-main"
}