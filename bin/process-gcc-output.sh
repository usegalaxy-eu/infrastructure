#!/bin/bash

ips="$(terraform output -json | jq -r '.gcc2019_ips.value[]')"
passwords="$(terraform output -json | jq -r '.gcc2019_pws.value[]')"
dns="$(terraform output -json | jq -r '.gcc2019_dns.value[]')"
lines=$(echo "$ips" | wc -l)
user="$(yes ubuntu | head -n $lines)"

paste <(echo "$user") <(echo "$dns") <(echo "$ips") <(echo "$passwords")
