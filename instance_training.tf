module "training-beta" {
  source = "modules/vgcn-node"
  count  = 1
  flavor = "c.c10m55"

  # custom image
  image       = "vggp-v31-j95-9c1a332fb4d7-master"
  name        = "training-beta"
  is_training = "True"
}

module "training-bioinfbrad2018_1" {
  source      = "modules/vgcn-node"
  count       = 1
  flavor      = "c.c10m55"
  name        = "training-bioinfbrad2018_1"
  is_training = "True"
}
