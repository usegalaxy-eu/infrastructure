#!/bin/bash
arr_cpu=(   10   16    40    4    )
arr_mem=(   55   120   250   22   )

for ((i=0;i<${#arr_cpu[@]};++i)); do
    cpu="${arr_cpu[i]}"
    mem="${arr_mem[i]}"
    flav_name="c.c${cpu}m${mem}"

    openstack flavor show $flav_name > /dev/null
    ec=$?

    if (( ec > 0 )); then
        # need to create flavor
        tot_ram=$(( mem * 1024 ));

        # Create it
        echo "Creating ${flav_name}"
        openstack flavor create \
            --ram ${tot_ram} \
            --disk 12 \
            --vcpus ${cpu} \
            --property quota:disk_read_iops_sec='5000' \
            --property quota:disk_write_iops_sec='5000' \
            --private \
            --project freiburg_galaxy \
            $flav_name > /dev/null;
    fi
done
