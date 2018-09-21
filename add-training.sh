#!/bin/bash
if (( $# != 1 )) && (( $# != 3 )); then
    echo "Usage:"
    echo
    echo "  $0 <training-identifier> <vm-size> <vm-count>"
    echo
    exit 1;
fi

training_identifier=$1
vm_size=${2:-c.c10m55}
vm_count=${3:-1}
output="instance_training-${training_identifier}.tf"

cat training-template.txt | \
    sed "s/TRAINING_IDENTIFIER/${training_identifier}/g" | \
    sed "s/VM_SIZE/${vm_size}/g" | \
    sed "s/VM_COUNT/${vm_count}/g" > $output

#echo "Done: instance_training-${training_identifier}.tf"


vm_cpu=$(echo $vm_size | sed 's/[^0-9]/ /g' | awk '{print $1}')
vm_mem=$(echo $vm_size | sed 's/[^0-9]/ /g' | awk '{print $2}')


echo "
Subject: Training Infrastructure Request: Approved

Hello,

We're happy to provide resources for your training. Based on your requested
training we have allocated ${vm_count} server(s), each with ${vm_cpu} Cores and ${vm_mem} GB of RAM.
This should be sufficient for your purposes. If you find that it is not, please contact us
and we can update that at any time.

On the day of your training, please ask your users to go to the following URL:
https://usegalaxy.eu/join-training/${training_identifier}

They will be added to the training group and put into a private queue which
should be a bit faster than our regular queue.

Please let us know if you have any questions!"
