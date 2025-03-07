#!/bin/bash

# HOW-TO use:
# Change permission: chmod +x ./identify_port.sh
# Execute: ./identify_port.sh
# For Python: Call with a device prefix as an argument, e.g., ./identify_port.sh "arduino"

# Global variable to store the tty device path
tty_result=""

# Function to check if lsusb is installed
check_lsusb() {
    if ! command -v lsusb &> /dev/null; then
        echo "Error: lsusb is not installed." >&2
        exit 1
    fi
}

# Function to get the device prefix (either from argument or user input)
get_device_prefix() {
    if [ $# -eq 1 ]; then
        device_prefix="$1"
    else
        echo "Enter the device name prefix (e.g., 'arduino', 'st-link', etc.): " >&2
        read -r device_prefix
    fi
}

# Function to find USB-serial devices and set tty_result
find_devices() {
    # Check if the device exists in lsusb
    device_line=$(lsusb | grep -i "$device_prefix")
    if [ -z "$device_line" ]; then
        return 1
    fi

    vid_pid=$(echo "$device_line" | grep -o "[0-9a-f]\{4\}:[0-9a-f]\{4\}")
    bus=$(echo "$device_line" | awk '{print $2}')
    device=$(echo "$device_line" | awk '{print $4}' | tr -d ':')

    # Look for a matching device in /dev/serial/by-id/ based on the prefix
    tty_dev=$(ls /dev/serial/by-id/* 2>/dev/null | grep -i "$device_prefix" | head -n 1)

    if [ -n "$tty_dev" ]; then
        real_dev=$(readlink -f "$tty_dev")
        tty_result="$real_dev"  # Set the global variable
        return 0
    else
        # Fallback: Use /sys/bus/usb/devices/ to find the tty device
        for sys_dev in /sys/bus/usb/devices/$bus-$device*; do
            if [ -d "$sys_dev" ]; then
                tty_dev=$(find "$sys_dev" -name "tty*" -type d | grep -o "tty[A-Za-z0-9]*" | head -n 1)
                if [ -n "$tty_dev" ]; then
                    real_dev="/dev/$tty_dev"
                    tty_result="$real_dev"  # Set the global variable
                    return 0
                fi
            fi
        done
    fi

    tty_result=""  # Clear the variable if no device is found
    return 1
}

main_func() {
    # Accept device prefix as an argument if provided
    get_device_prefix "$@"
    check_lsusb
    find_devices

    # Output only the tty_result (if found) for Python to capture
    if [ -n "$tty_result" ]; then
        echo "$tty_result"
    fi
}

# Run main_func with any passed arguments
main_func "$@"
