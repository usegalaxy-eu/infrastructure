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

# Until 2018-11-23
module "training-big-data2018" {
  # 11/19/2018
  # 11/23/2018
  source = "modules/vgcn-node"

  count       = 10
  flavor      = "c.c16m120"
  name        = "training-big-data2018"
  galaxygroup = "training-big-data2018"
  is_training = "True"
}

# Until 2018-11-23
module "training-emc2018" {
  # 11/22/2018
  # 11/23/2018
  source = "modules/vgcn-node"

  count       = 15
  flavor      = "c.c16m120"
  name        = "training-emc2018"
  galaxygroup = "training-emc2018"
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
