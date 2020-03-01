#!/bin/bash

ips="$(terraform output -json | jq -r '.training_ips.value[]')"
passwords="$(terraform output -json | jq -r '.training_pws.value[]')"
dns="$(terraform output -json | jq -r '.training_dns.value[]')"
lines=$(echo "$ips" | wc -l)
user="$(yes ubuntu | head -n $lines)"

paste <(echo "$user") <(echo "$dns") <(echo "$passwords")
