#!/usr/bin/bash

# Making sure all arguments are passed
if [ $# -lt 2 ]; then
    echo "ERROR"
    echo "$0 needs two arguments"
    echo "dir — the source directory being monitored (files only, no subdirectories)"
    echo "malicious_dir — the destination directory where flagged/quarantined files are copied"
    echo
    exit 1
fi

# Storing arguments as variables
dir="$1"
malicious_dir="$2"
file=""
option=""

# Making sure both directories exist
if [ ! -d "$dir" ]; then
    echo "dir: directory provided does not exist"
    exit 1
fi

if [ ! -d "$malicious_dir" ]; then
    echo "malicious_dir: directory provided does not exist"
    exit 1
fi

function list {
    found=false
    
    for f in "$malicious_dir"/*; do
        echo "${f##*/}"
        found=true
    done

    if [ "$found" == false ]; then
        echo "No malicious files to review."
        return 1
    fi
    return 0
}

function menu {
    # Allow file selection from list
    local choice selected_option
    # Prompt for filename until a valid one is given (or empty to cancel)
    while true; do
        # Read user input
        read -r -p "Enter filename to review: " choice

        # Verify that file exists in the list
        if [ -f "$malicious_dir/$choice" ]; then
            break
        fi

        # Output to error stream
        echo "No such file in $malicious_dir: $choice" >&2
    done

    # Present options
    echo
    echo "Selected: $choice"
    echo "  1) Restore this file back into $dir"
    echo "  2) Permanently delete this file from $malicious_dir"
    echo "  3) Leave this file as-is and go back to the list"
    echo

    while true; do
        read -r -p "Choice [1-3]: " selected_option

        [[ "$selected_option" -ge 1 && "$selected_option" -le 3 ]] && break
        
        # Output to error stream
        echo "Invalid choice, enter 1, 2, or 3." >&2
    done

    # Return selection
    file="$choice"
    option="$selected_option"
}

# Main loop
while true; do
    # List flagged files, stop program if no files are found
    list || break
    echo

    # Get user selection
    menu

    if [ "$option" == 1 ]; then
        mv "$malicious_dir/$file" "$dir/$file"
        echo "Restored $file to $dir."
        continue
    fi

    if [ "$option" == 2 ]; then
        rm "$malicious_dir/$file"
        echo "$file permanently deleted."
        continue
    fi
done