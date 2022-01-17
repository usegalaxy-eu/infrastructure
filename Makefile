help:
	@echo "Run 'make all' to sync resources."
	@echo ""

all: ## Sync resources
	terraform init
	terraform fmt
	terraform validate
	terraform apply

fmt:
	terraform fmt
	terraform validate

encrypt: ## Encrypt the state file
	ansible-vault encrypt terraform.tfstate        --vault-password-file .vault_password
	ansible-vault encrypt terraform.tfstate.backup --vault-password-file .vault_password

decrypt: ## Decrypt the state file
	ansible-vault decrypt terraform.tfstate        --vault-password-file .vault_password
	ansible-vault decrypt terraform.tfstate.backup --vault-password-file .vault_password

.PHONY: help all
