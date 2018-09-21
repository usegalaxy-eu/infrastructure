#!/bin/bash
set -ex
condor_drain $(hostname) || true;

# My address:
my_ip=$(/sbin/ifconfig eth0 | grep 'inet ' | awk '{print $2}')

# Find slots which have an address associated with us.
slots=$(condor_status -autoformat Name State MyAddress | grep "<${my_ip}?9618" | wc -l)

# If there are more than one slots, leave it.
if (( slots > 1 )); then
    exit 1;
else
    # Otherwise, poweroff.
    /usr/sbin/condor_off -graceful
    exit 0;
fi
