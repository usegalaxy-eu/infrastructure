module "training-bioinfbrad2018_1" {
  # Until 12/16/2018
  source      = "modules/vgcn-node"
  count       = 1
  flavor      = "c.c10m55"
  name        = "training-bioinfbrad2018_1"
  galaxygroup = "training-bioinfbrad2018_1"
  is_training = "True"
}

module "training-bioinformatika2018" {
  # 12/31/2018
  source = "modules/vgcn-node"

  count       = 2
  flavor      = "c.c16m120"
  name        = "training-bioinformatika2018"
  galaxygroup = "training-bioinformatika2018"
  is_training = "True"
}

module "training-genomika3" {
  # Until 12/4/2018
  source      = "modules/vgcn-node"
  count       = 2
  flavor      = "c.c32m240"
  name        = "training-genomika3"
  galaxygroup = "training-genomika3"
  is_training = "True"
}
