#!/bin/bash

# This is a script to start scripts in a organized way
#
# HOW-TO USE:
# 1. Configure permissions: chmod +x start_script.sh
# 2. Execute: ./start_script.sh [script_file_path]
#

# Check if a script path was provided
if [ $# -ne 1 ]; then
    echo "Usage: $0 /path/to/your/python_script.py"
    exit 1
fi

# Check if file exists and is a Python script
if [ ! -f "$1" ] || [ "${1##*.}" != "py" ]; then
    echo "Error: Please provide a valid Python script (.py file)"
    exit 1
fi

# Get the absolute path of the script
SCRIPT_PATH=$(realpath "$1")
SCRIPT_NAME=$(basename "$1")
LOG_FILE="${SCRIPT_PATH%.*}.log"

# Ensure log file is writable
touch "$LOG_FILE" 2>/dev/null || {
    echo "Error: Cannot write to log file $LOG_FILE - check permissions"
    exit 1
}

# Start the script in the background with nohup and redirect both stdout and stderr
nohup python3 "$SCRIPT_PATH" >> "$LOG_FILE" 2>&1 &
PID=$!

# Store process info in a temporary file
echo "$PID $SCRIPT_NAME $(date +%s) $SCRIPT_PATH" >> ~/.running_scripts.log

echo "Started '$SCRIPT_NAME' with PID $PID"
echo "Output will be logged to $LOG_FILE"
