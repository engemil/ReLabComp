#!/bin/bash

# This is a script to stop running scripts
#
# HOW-TO USE:
# 1. Configure permissions: chmod +x stop_script.sh
# 2. Execute: ./stop_script.sh [PID]
#

if [ $# -ne 1 ]; then
    echo "Usage: $0 PID"
    exit 1
fi

PID=$1

# Check if the PID exists in our tracking file
if ! grep -q "^$PID " ~/.running_scripts.log; then
    echo "No tracked script found with PID $PID"
    exit 1
fi

# Kill the process
if kill -9 "$PID" 2>/dev/null; then
    # Remove from tracking file
    grep -v "^$PID " ~/.running_scripts.log > /tmp/running_scripts.tmp
    mv /tmp/running_scripts.tmp ~/.running_scripts.log
    echo "Script with PID $PID has been stopped"
else
    echo "Failed to stop script with PID $PID"
fi
