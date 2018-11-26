module "training-bioinfbrad2018_1" {
  source      = "modules/vgcn-node"
  count       = 1
  flavor      = "c.c10m55"
  name        = "training-bioinfbrad2018_1"
  galaxygroup = "training-bioinfbrad2018_1"
  is_training = "True"
}

# Until 2018-11-25
module "training-ucabgt2018" {
  source      = "modules/vgcn-node"
  count       = 4
  flavor      = "c.c10m55"
  name        = "training-ucabgt2018"
  galaxygroup = "training-ucabgt2018"
  is_training = "True"
}

module "training-genomika2" {
  source      = "modules/vgcn-node"
  count       = 1
  flavor      = "c.c32m240"
  name        = "training-genomika2"
  galaxygroup = "training-genomika2"
  is_training = "True"
}

module "training-bioinformatika2018" {
# 11/26/2018 - 12/31/2018
  source = "modules/vgcn-node"

  count       = 2
  flavor      = "c.c16m120"
  name        = "training-bioinformatika2018"
  galaxygroup = "training-bioinformatika2018"
  is_training = "True"
}
