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
  default = "jenkins-worker-v60-j105-d1dfcf46c4cd-main"
}

variable "jenkins_userdata" {
  default = <<-EOF
    #cloud-config
    bootcmd:
        - test -z "$(blkid /dev/vdb)" && mkfs -t ext4 -L jenkins /dev/vdb
        - mkdir -p /scratch
    mounts:
        - ["/dev/vdb", "/scratch", auto, "defaults,nofail", "0", "2"]
    runcmd:
        - [ chown, "centos.centos", -R, /scratch ]
    packages: # ensure the currently used python versions for virtualenv builder are installed
        - python3.9
        - python3.8
    write_files:
        - encoding: b64
          content:|
            github.com ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIOMqqnkVzrm0SdG6UOoqKLsabgH5C9okWi0dh2l9GKJl
            github.com ecdsa-sha2-nistp256 AAAAE2VjZHNhLXNoYTItbmlzdHAyNTYAAAAIbmlzdHAyNTYAAABBBEmKSENjQEezOmxkZMy7opKgwFB9nkt5YRrYMjNuG5N87uRgg6CLrbo5wAdT/y6v0mKV0U2w0WZ2YB/++Tpockg=
            github.com ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABgQCj7ndNxQowgcQnjshcLrqPEiiphnt+VTTvDP6mHBL9j1aNUkY4Ue1gvwnGLVlOhGeYrnZaMgRK6+PKCUXaDbC7qtbW8gIkhL7aGCsOr/C56SJMy/BCZfxd1nWzAOxSDPgVsmerOBYfNqltV9/hWCqBywINIR+5dIg6JTJ72pcEpEjcYgXkE2YEFXV1JHnsKgbLWNlhScqb2UmyRkQyytRLtL+38TGxkxCflmO+5Z8CSSNY7GidjMIZ7Q4zMjA2n1nGrlTDkzwDCsw+wqFPGQA179cnfGWOWRVruj16z6XyvxvjJwbz0wQZ75XK5tKSb7FNyeIEs4TT4jk+S4dhPeAUC5y+bDYirYgM4GC7uEnztnZyaVWQ7B381AK4Qdrwt51ZqExKbQpTUNn+EjqoTwvqNj4kqx5QUCI0ThS/YkOxJCXmPUWZbhjpCg56i+2aB6CmK2JGhn57K5mj0MNdBXA4/WnwH6XoPWJzK5Nyu2zB3nAZp+S5hpQs+p1vN1/wsjk=
          owner: centos:centos
          path: /home/centos/.ssh/known_hosts
          permissions: '0644'
  EOF
}
