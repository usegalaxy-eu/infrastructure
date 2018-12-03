all: ## Sync resources
	terraform init
	terraform fmt
	terraform validate
	terraform apply


fmt:
	terraform fmt

cleanup-images: ## Remove unused Images
	openstack image list -c ID -c Name -f value | grep vggp | awk '{print $1}' | xargs --no-run-if-empty openstack image delete

cleanup-vms: ## Remove failed/off VMs
	openstack server list --name 'vgcnbwc' -f value | grep -v ACTIVE | grep -v BUILD | awk '{print $$1}' | xargs --no-run-if-empty openstack server delete

find-unmanaged: ## Identify any resources that are not currently managed
	./bin/find-unmanaged.sh

help: ## This message
	@egrep '^[a-zA-Z_-]+:.*?## .*$$' $(MAKEFILE_LIST) | sort | awk 'BEGIN {FS = ":.*?## "}; {printf "\033[36m%-10s\033[0m %s\n", $$1, $$2}'

fetch-apply: ## Fetch and apply
	git fetch
	git reset --hard origin/master
	$(MAKE) cleanup-vms
	$(MAKE)

.PHONY: help all find-unmanaged
