#!/bin/bash
if (( $# > 0 )); then
	DOMAIN="-$1";
fi

ips="$(terraform output -json | jq -r '."training_ips'$DOMAIN'".value[]')"
passwords="$(terraform output -json | jq -r '."training_pws'$DOMAIN'".value[]')"
dns="$(terraform output -json | jq -r '."training_dns'$DOMAIN'".value[]')"
lines=$(echo "$ips" | wc -l)
user="$(yes ubuntu | head -n $lines)"

paste <(echo "$user") <(echo "$ips") <(echo "$dns") <(echo "$passwords")
