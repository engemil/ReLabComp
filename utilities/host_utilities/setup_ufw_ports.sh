#!/bin/bash

#
# Script for setup UFW ports
#
# HOW-TO-USE:
# 1. Change permission: sudo chmod +x ./setup_ufw_ports.sh
# 2. Execute script: sudo ./setup_ufw_ports.sh
#
# NOTE: If you do not have sudo installed, I assume you are
#       using a root user and do not need sudo for this script.
#

##################################################


# Function to ask for confirmation
confirm() {
    while true; do
        read -p "$1 (y/n): " answer
        case $answer in
            [Yy]* ) return 0;;
            [Nn]* ) return 1;;
            * ) echo "Please answer yes (y) or no (n).";;
        esac
    done
}

##################################################

if confirm "Do you want setup new ports for Uncomplicated Firewall (UFW)?"; then

    # Prompt for additional ports
    read -p "Enter ports to open (space-separated, e.g., '80 443'), or press Enter to skip: " ports
    
    # Check if ports variable is not empty
    if [ ! -z "$ports" ]; then
        # Convert space-separated ports into array
        IFS=' ' read -r -a port_array <<< "$ports"
        
        # Add each port to UFW
        for port in "${port_array[@]}"; do
            # Check if port is a valid number
            if [[ "$port" =~ ^[0-9]+$ ]]; then
                ufw allow "$port"
                echo "Allowed port $port"
            else
                echo "Invalid port number: $port - skipping"
            fi
        done
    else
        echo "No additional ports specified"
    fi

    # Check if UFW is active
    if ufw status | grep -q "Status: active"; then
        echo "Reloading UFW..."
        ufw reload
    else
        echo "Enabling UFW..."
        ufw enable
    fi

else
    echo "Skipping setting up new ports for UFW."
fi

echo ""