#!/bin/bash

# HOW-TO use:
# Change permission: chmod +x ./identify_port.sh
# Execute: ./identify_port.sh



# Function to check if lsusb is installed
check_lsusb() {
    if ! command -v lsusb &> /dev/null; then
        echo "lsusb is not installed. Do you want to install it? (y/n)"
        read -r install_choice
        if [[ $install_choice == "y" || $install_choice == "Y" ]]; then
            sudo apt update && sudo apt install -y usbutils
        else
            echo "lsusb is required to run this script. Exiting."
            exit 1
        fi
    fi
}

# Function to get the user's preferred device name prefix
get_device_prefix() {
    echo -n "Enter the device name prefix (e.g., 'arduino', 'st-link', etc.): "
    read -r device_prefix
    echo ""
}


# Function to find USB-serial devices and return the tty path
find_devices() {
    echo "Detecting USB device(s) with prefix '$device_prefix'..."
    echo ""

    device_line=$(lsusb | grep -i "$device_prefix")
    #echo "Detected: $device_line"

    if [ -z "$device_line" ]; then
        echo "No '$device_prefix' device found."
        return 1
    fi

    vid_pid=$(echo "$device_line" | grep -o "[0-9a-f]\{4\}:[0-9a-f]\{4\}")
    #vid_pid=$(echo "$device_line" | awk '{print $6}') # Alterantive way    
    bus=$(echo "$device_line" | awk '{print $2}')
    device=$(echo "$device_line" | awk '{print $4}' | tr -d ':')
    echo "Found '$device_prefix' (VID:PID) $vid_pid at Bus $bus, Device $device"

    tty_dev=$(ls /dev/serial/by-id/*"$vid_pid"* 2>/dev/null | head -n 1)

    if [ -n "$tty_dev" ]; then
        real_dev=$(readlink -f "$tty_dev")
        echo "Device '$device_prefix' is connected to: $real_dev"
        return 0
    fi

    echo "No /dev/tty* device found for '$device_prefix'."
    #echo "No /dev/tty* device found for '$device_prefix' in /dev/serial/by-id/."
    return 1
}

main_func() {
    # Run functions
    check_lsusb
    get_device_prefix
    find_devices
}

# Run main func
main_func
