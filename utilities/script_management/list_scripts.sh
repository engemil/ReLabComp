#!/bin/bash

# This is a script to list running scripts that started from start_script.sh
#
# HOW-TO USE:
# 1. Configure permissions: chmod +x list_scripts.sh
# 2. Execute: ./list_scripts.sh
#

# Check if the tracking file exists
if [ ! -f ~/.running_scripts.log ]; then
    echo "No running scripts found"
    exit 0
fi

echo "PID    Script Name    Runtime    Location"
echo "----------------------------------------"

# Read the tracking file line by line
while read -r line; do
    # Split the line into PID, name, start time, and path
    read pid name start_time location <<< "$line"
    
    # Check if process is still running
    if ps -p "$pid" > /dev/null 2>&1; then
        # Calculate runtime in seconds
        current_time=$(date +%s)
        runtime=$((current_time - start_time))
        
        # Convert to hours:minutes:seconds
        hours=$((runtime / 3600))
        minutes=$(((runtime % 3600) / 60))
        seconds=$((runtime % 60))
        
        printf "%-6s %-15s %-11s %s\n" "$pid" "$name" "${hours}h ${minutes}m ${seconds}s" "$location"
    else
        # Remove dead processes from the tracking file
        grep -v "^$pid " ~/.running_scripts.log > /tmp/running_scripts.tmp
        mv /tmp/running_scripts.tmp ~/.running_scripts.log
    fi
done < ~/.running_scripts.log
