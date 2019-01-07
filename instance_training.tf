module "training-bioinformatika2018" {
  # 12/31/2018
  source = "modules/vgcn-node"

  count       = 2
  flavor      = "c.c16m120"
  name        = "training-bioinformatika2018"
  galaxygroup = "training-bioinformatika2018"
  is_training = "True"
}
