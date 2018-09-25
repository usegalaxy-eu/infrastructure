all: ## Sync resources
	terraform fmt
	terraform validate
	terraform apply


find-unmanaged: ## Identify any resources that are not currently managed
	bash ./find-unmanaged.sh

help: ## This message
	@egrep '^[a-zA-Z_-]+:.*?## .*$$' $(MAKEFILE_LIST) | sort | awk 'BEGIN {FS = ":.*?## "}; {printf "\033[36m%-10s\033[0m %s\n", $$1, $$2}'

.PHONY: help all find-unmanaged
