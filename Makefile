all:
	terraform fmt
	terraform validate
	terraform apply
