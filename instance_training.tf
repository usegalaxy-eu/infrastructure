# Until 2018-01-19
module "training-bioinformatika" {
  source      = "modules/vgcn-node"
  count       = 4
  flavor      = "c.c40m1000"
  name        = "training-bioinformatika"
  galaxygroup = "training-bioinformatika"
  is_training = "True"
}
