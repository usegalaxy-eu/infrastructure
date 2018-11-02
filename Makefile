all: ## Sync resources
	terraform init
	terraform fmt
	terraform validate
	terraform apply


fmt:
	terraform fmt

find-unmanaged: ## Identify any resources that are not currently managed
	./bin/find-unmanaged.sh

help: ## This message
	@egrep '^[a-zA-Z_-]+:.*?## .*$$' $(MAKEFILE_LIST) | sort | awk 'BEGIN {FS = ":.*?## "}; {printf "\033[36m%-10s\033[0m %s\n", $$1, $$2}'

.PHONY: help all find-unmanaged
