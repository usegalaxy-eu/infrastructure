
module "training-bactannot" {
  source      = "modules/vgcn-node"
  count       = 2
  flavor      = "c.c40m1000"
  name        = "training-bactannot"
  galaxygroup = "training-bactannot"
  is_training = "True"
}

