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
    echo "Detecting USB devices..."
    echo ""
    echo "Listing up all USB devices:"
    # Show connected USB devices
    lsusb_output=$(lsusb)
    echo "$lsusb_output"
    echo ""
    # Check for matching serial devices in /dev/serial/by-id/
    if [ -d "/dev/serial/by-id/" ]; then
        echo "Checking /dev/serial/by-id/ for devices matching '$device_prefix'..."
        echo ""
        matching_device=$(ls /dev/serial/by-id/ 2>/dev/null | grep -i "$device_prefix" | head -n 1)

        if [ -n "$matching_device" ]; then
            device_path=$(readlink -f "/dev/serial/by-id/$matching_device")
            echo "$device_path"
            return 0
        fi
    fi

    # If no match is found, return an error
    echo "No devices found matching '$device_prefix'."
    return 1
}






# Run functions
check_lsusb
get_device_prefix
find_devices
