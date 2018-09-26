#!/bin/bash
managed_resources=$(mktemp)

error() {
	echo -e "\e[48;5;09m$@\e[m"
}

success() {
	echo -e "\e[38;5;40m$@\e[m"
}

# Load all resources
terraform show | \
    # Look for no space or __id
    egrep '^([^ ]|  id)' | \
    # Paste them together in two column format
    paste -d " " - - | \
    # Return a two column file with (resource_type, ID)
    sed 's/id = //g;s/\..*:  //g' > ${managed_resources}

# Now check things:
for resource in {volume,server,keypair,security\ group}; do
    success "Checking ${resource}"
    if [[ "${resource}" == "keypair" ]]; then
        column=Name
    else
        column=ID
    fi;

    for id in $(openstack ${resource} list -c ${column} -f value); do
        grep --quiet ${id} ${managed_resources};
        ec=$?
        if (( $ec != 0 )); then
            error "Unmanaged ${resource}: ${id}"
        fi
    done
done


success "Checking domains"

for domain in {Z391FYOSFHL9U7,Z3BOXJYLR7ZV7D,Z2LADCUB4BUBWX}; do
    tmp_ids=`mktemp`
    # Find records under this domain
    aws route53 list-resource-record-sets --hosted-zone-id ${domain} | \
        # Ignore SOA and NS records
        jq '.ResourceRecordSets[] | select (.Type != "SOA") | select(.Type != "NS")' | \
        # Reformat as a terraform ID
        jq '. | "'${domain}'_" + .Name + "_" + .Type' -r | \
        # domains from aws end in `.`
        sed 's/\._/_/' > ${tmp_ids}

    for id in `cat ${tmp_ids}`; do
        grep --quiet ${id} ${managed_resources};
        ec=$?
        if (( $ec != 0 )); then
            error "Unmanaged: ${id}"
        fi
    done

    rm ${tmp_ids}
done

rm ${managed_resources}
