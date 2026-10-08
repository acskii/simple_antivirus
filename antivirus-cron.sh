#!/usr/bin/bash

# To make sure commands are run from /usr/bin as expected
PATH=/usr/bin
export PATH

# Making sure all arguments are passed
if [ $# -lt 2 ]; then
    echo "ERROR"
    echo "$0 needs three arguments"
    echo "dir — the source directory being monitored (files only, no subdirectories)"
    echo "malicious_dir — the destination directory where flagged/quarantined files are copied"
    echo
    exit 1
fi

# Constants
script_dir="$(cd $(dirname "$0") && pwd)"   # Get absolute path to state files
last_state="$script_dir/directory-info.last"
new_state="$script_dir/directory-info.new"
malicious_ext=(".exe" ".bat" ".vbs" ".scr" ".ps1")
malicious_text=("virus" "trojan" "malware" "worm" "ransomware")

# Storing arguments as variables
dir="$1"
malicious_dir="$2"

# Making sure both directories exist
if [ ! -d "$dir" ]; then
    echo "dir: directory provided does not exist"
    exit 1
fi

if [ ! -d "$malicious_dir" ]; then
    echo "malicious_dir: directory provided does not exist"
    exit 1
fi

function act {
    file="$1"

    cp "$dir/$file" "$malicious_dir/$file"

    rm "$dir/$file"

    echo "$file is malicious and it is DELETED"
}

function scan {
    for file in "$dir"/*; do
        # Extract only file basename
        [ -f "$file" ] || continue
        filename="${file##*/}"
        m=false

        # Check file extension against malicious ones
        for ext in "${malicious_ext[@]}"; do
            if [[ "$filename" == *"$ext" ]]; then
                m=true
                break
            fi
        done

        # Check file content against malicious words
        for word in "${malicious_text[@]}"; do
            if grep -q "$word" "$file"; then
                m=true
                break
            fi
        done

        # Act on malicious detection
        [ "$m" == true ] && act "$filename"
    done
}

# Perform state preservation and initial scan
# if directory-info.last does not exist
if [ ! -f "$last_state" ]; then
    scan
    ls -l "$dir" > "$last_state"
fi

# Update new_state
ls -l "$dir" > "$new_state"

# Compare state differences, skip if no change
cmp -s "$new_state" "$last_state" && continue

# Perform file scan
scan

# Update last_state
ls -l "$dir" > "$last_state"