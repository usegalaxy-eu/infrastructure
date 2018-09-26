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


rm ${managed_resources}
