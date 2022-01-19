VAULT_PASSWORD_FILE = .vault_password

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
	ansible-vault encrypt terraform.tfstate        --vault-password-file $(VAULT_PASSWORD_FILE)
	ansible-vault encrypt terraform.tfstate.backup --vault-password-file $(VAULT_PASSWORD_FILE)

decrypt: ## Decrypt the state file
	ansible-vault decrypt terraform.tfstate        --vault-password-file $(VAULT_PASSWORD_FILE)
	ansible-vault decrypt terraform.tfstate.backup --vault-password-file $(VAULT_PASSWORD_FILE)

.PHONY: help all
