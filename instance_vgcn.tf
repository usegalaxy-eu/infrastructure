module "compute-highmem" {
  source = "modules/vgcn-node"
  count  = 20
  flavor = "c.c20m120"
  name   = "compute-highmem"
}

module "compute-general" {
  source = "modules/vgcn-node"
  count  = 20
  flavor = "c.c10m55"
  name   = "compute-general"
}

module "sklearn" {
  source      = "modules/vgcn-node"
  count       = 5
  flavor      = "c.c10m55"
  name        = "sklearn"
  galaxygroup = "sklearn"
}

module "compute-superhighmem" {
  source = "modules/vgcn-node"
  count  = 15
  flavor = "c.c32m240"
  name   = "compute-superhighmem"
}

module "upload" {
  source      = "modules/vgcn-node"
  count       = 2
  flavor      = "m1.xlarge"
  name        = "upload"
  galaxygroup = "upload"
}
