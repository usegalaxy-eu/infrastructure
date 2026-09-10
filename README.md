# UseGalaxy.eu Infrastructure [![Build Status](https://build.galaxyproject.eu/buildStatus/icon?job=usegalaxy-eu%2Finfrastructure)](https://build.galaxyproject.eu/job/usegalaxy-eu/job/infrastructure/)

Our UseGalaxy.eu infrastructure is defined in this repository. A Jenkins job
runs Terraform periodically to ensure our infrastructure converges to the
state defined here.

> [!CAUTION]
> - This is our actual infrastructure.
> - Changes made here can be damaging.
> - Terraform catches some mistakes but not all.
> - Be careful.

> [!IMPORTANT]
> At the moment, this repository only manages DNS records (via AWS Route53).

All changes should go through __pull requests__ and never be merged directly
to the main branch. The Jenkins bot will post the `terraform plan` output on
the PR. Any changes applied via an external API or UI (e.g. AWS Route53
console), will be reverted by the Jenkins job.
