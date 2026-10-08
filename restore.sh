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
files=()

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
    local -i found=0
    files=()
    
    for f in "$malicious_dir"/*; do
        if [ -f "$f" ]; then
            found+=1
            files+=("${f##*/}")
        fi
    done

    if [ "$found" -eq 0 ]; then
        echo "No malicious files to review."
        return 1
    fi
    return 0
}

function menu {
    # Allow file selection from list
    local selected_option
    local OLD_PS3="$PS3"

    PS3="> "

    while true; do
        # Present the files using the native select prompt
        select choice in "${files[@]}"; do
            # choice will contain the actual filename string if valid
            if [[ -n "$choice" ]]; then
                echo
                echo "For: $choice"
                echo "  1) Restore this file back into $dir"
                echo "  2) Permanently delete this file from $malicious_dir"
                echo "  3) Leave this file as-is and go back to the list"
                echo

                while true; do
                    read -r -p "> " selected_option
                    if [[ "$selected_option" =~ ^[1-3]$ ]]; then
                        break
                    fi
                    echo "Invalid choice, enter 1, 2, or 3." >&2
                done

                # Assign the global variables safely
                file="$choice"
                option="$selected_option"
                
                # Break out of the select loop
                break 2 
            else
                # $REPLY contains what they typed if it was invalid
                echo "No such option: $REPLY" >&2
                break
            fi
        done
    done
    PS3="$OLD_PS3"
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