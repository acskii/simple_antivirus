#!/usr/bin/bash

# Making sure all arguments are passed
if [ $# -lt 3 ]; then
    echo "ERROR"
    echo "$0 needs three arguments"
    echo "dir — the source directory being monitored (files only, no subdirectories)"
    echo "malicious_dir — the destination directory where flagged/quarantined files are copied"
    echo "interval_secs — time to wait between every check"
    echo
    exit 1
fi

# Constants
last_state="./directory-info.last"
new_state="./directory-info.new"

# Storing arguments as variables
dir="$1"
malicious_dir="$2"
interval="$3"

# Making sure both directories exist
if [ ! -d "$dir" ]; then
    echo "dir: directory provided does not exist"
    exit 1
fi

if [ ! -d "$malicious_dir" ]; then
    echo "malicious_dir: directory provided does not exist"
    exit 1
fi

# Making sure interval is positive
if [ $interval -le 0 ]; then
    echo "interval_secs: interval must be positive"
    exit 1
fi

# Perform state preservation 
# if directory-info.last does not exist
if [ ! -f "$last_state" ]; then
    ls -l "$dir" > directory-info.last
fi

function scan {
    echo "Difference found"
}

# Main loop
# Only run every <interval> seconds
while true; do
    sleep $interval
    ls -l "$dir" > directory-info.new

    # Compare state differences, skip if no change
    cmp -s "$new_state" "$last_state" && continue

    # Perform file scan
    scan

    # Update last_state with new_state
    cp "$new_state" "$last_state"
done