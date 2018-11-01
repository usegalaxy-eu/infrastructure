module "compute-highmem" {
  source = "modules/vgcn-node"
  count  = 30
  flavor = "c.c20m120"
  name   = "compute-highmem"
}

module "compute-general" {
  source = "modules/vgcn-node"
  count  = 4
  flavor = "c.c10m55"
  name   = "compute-general"
}

module "compute-superhighmem" {
  source = "modules/vgcn-node"
  count  = 4
  flavor = "c.c32m240"
  name   = "compute-superhighmem"
}

module "metadata" {
  source = "modules/vgcn-node"
  count  = 0
  flavor = "m1.xlarge"
  name   = "metadata"
}

module "upload" {
  source = "modules/vgcn-node"
  count  = 2
  flavor = "m1.xlarge"
  name   = "upload"
}
