# UseGalaxy.eu Infrastructure

**ACHTUNG** **ACHTUNG** **ACHTUNG**

- This is our actual infrastructure.
- Changes made here can be damaging.
- Be careful.
- Terraform catches some mistakes but not all

-----

## Setup

[Download](https://www.terraform.io/downloads.html) terraform if you haven't already.

```
terraform init # downloads openstack + aws plugins
. /path/to/openstack-creds.sh
```

## Running

```
make
```

## Layout/Theory

We're using this to manager every cloud resource. If it is something you would
do with the OpenStack API or UI, **do not do it.** Instead, use this repository
for it.

Our DNS provider is Amazon AWS/Route53 since they have a mostly reliable service
and a nice API.

### Variables

All important variables like flavour names, AWS Route53 zones, groups of
security groups for default things like webservices, etc. go in the variables
file.

```
variable "vgcn_image" {
  default = "vggp-v31-j74-edc5aa3dc22c-master"
}
```

defines a variable and then you can use this with `${var.vgcn_image}`

### Instances

All instances are stored in files named `instance_<name>.tf`. Their structure is
not too complex:

```
#        type of resource                 resource name
resource "openstack_compute_instance_v2" "apollo-usegalaxy" {
  # Server name in the OpenStack api. becomes the internal hostname with
  # .novalocal appended
  name            = "apollo.usegalaxy.eu"

  # We have several variables for you to choose from in the vars.tf file.
  image_name      = "${var.centos_image}"

  flavor_name     = "m1.large"
  key_pair        = "cloud2"

  # You can define this as a list or use the var.sg_webservice for all of the
  # default security groups required for a webservice (egress, ufr ssh, public
  # ICMP, public http(s))
  security_groups = "${var.sg_webservice}"

  # Here we attach two networks:
  network {
    name = "bioinf"
  }

  network {
    name = "public"
  }
}

# Here we define a DNS record for this VM
resource "aws_route53_record" "apollo-usegalaxy" {
  # The zone needs to be correct for the TLD you want.
  zone_id = "${var.zone_usegalaxy_eu}"
  # The actual record
  name    = "apollo.usegalaxy.eu"
  type    = "A"
  ttl     = "7200"

  # Here we use a computed value from the first resource, format is from above:
  # "type of resource"."resource name".access_ip_v4
  records = ["${openstack_compute_instance_v2.apollo-usegalaxy.access_ip_v4}"]
}
```

When you run `make` terraform will sync, and if VMs need to be destroyed and
re-created, they will and DNS records will update appropriately.

### Compute Instances

These have an extra step whereby there are some additional commands that are run
before shutdown:

```
resource "openstack_compute_instance_v2" "vgcn-compute-general" {
  # snip

  # The user data file is mostly self-explanatory. That data will be added into
  # the VM during launch. Whenever that file changes, terraform is aware, and will
  # register that the VM should be DESTROYED and replaced.
  user_data = "${file("conf/node.yml")}"

  # This is a provisioner which executes commands remotely
  provisioner "remote-exec" {
    # Most provisioners run on instantiation, however here we declare one for
    # before destruction
    when = "destroy"

    # These scripts will be copied over and executed
    scripts = [
      "./conf/prepare-restart.sh",
    ]

    # Using an SSH connection with these parameters
    connection {
      type        = "ssh"
      user        = "centos"
      private_key = "${file("~/.ssh/keys/id_rsa_cloud2")}"
    }
  }
}
```


#### prepare-restart.sh

This script is designed to:

- drain the host
- find out how many slots are used (i.e. jobs executing on local host)
  - if > 1: exit 1 (i.e. the `prepare-restart.sh` failed, terraform should try
    again later.)
  - else: issue `condor_off` and exit 0

This should result in terraform promptly removing nodes from the `condor_status`
output whenever they're to be shutdown.

Currently the behaviour is **STRICTLY WORSE** than our
[vgcn-infrastructure](https://github.com/usegalaxy-eu/vgcn-infrastructure). I am
not certain what we should do about this. Terraform has a [open
bug](https://github.com/hashicorp/terraform/issues/13549) bug for
`create_before_destory` which would allow maintaining a minimum number of instances.
There is additionally a
[closed/wontfix](https://github.com/hashicorp/terraform/issues/2896) but for
rolling re-deployments.

We will need to solve this at *some point* but that point is not now. We could
do weird stuff like having an `-a` and `-b` version of the file and slowly
increasing count in one and decreasing it in the other and running `terraform
apply` each time. But none of the solutions are optimal. We might go back to the
vgcn-infrastructure code, albeit once I get it working with the openstack CLI
since that is more stable than the python code.

### Training Nodes

There is a script for adding the appropriate stanzas for a training instance:

```
$ ./add-training.sh

Usage:
  ./add-training.sh <training-identifier> <vm-size> <vm-count>
```

which will output a file named `instance_training-<identifier>.tf`. You should
commit this.
