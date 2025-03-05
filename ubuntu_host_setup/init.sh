#!/bin/bash

#
# Script for setting up Ubuntu host-computer (NOT FOR CONTAINERS)
#
# HOW-TO-USE:
# 1. Change permission: sudo chmod +x ./init.sh
# 2. Execute script: sudo ./init.sh
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

# Initializing script
echo "Initial Setup Server script started..."
echo ""

##################################################

if [ "$EUID" -ne 0 ]; then
  echo "Stopped! Please run this script as root (use sudo)!"
  exit 1
fi

##################################################

# Update and Upgrade
echo "Updating and Upgrading operative system..."
apt update -y
apt upgrade -y

echo ""

##################################################

echo "Installing essentials..."

echo ""

# Install git
echo "Installing git..."
apt install git -y

echo ""

# Install curl
echo "Installing curl..."
apt install curl -y

echo ""

# Install usb utilities (lsusb)
echo "Installing usbutils..."
apt install usbutils -y

echo ""

##################################################

if confirm "Do you want to setup static IP for this computer?"; then

    echo "Setting up static IP for this computer..."
    # Prompt user for network interface
    echo "Available network interfaces:"
    ip link | grep -E '^[0-9]:' | awk '{print $2}' | tr -d ':'
    read -p "Enter the network interface (e.g., eth0 for wired, wlan0 for WiFi): " INTERFACE

    # Prompt user for network details
    read -p "Enter the static IP address (e.g., 192.168.1.100): " IP_ADDRESS
    read -p "Enter the subnet mask (e.g., 255.255.255.0 or /24): " SUBNET
    read -p "Enter the gateway address (e.g., 192.168.1.1): " GATEWAY
    read -p "Enter the DNS server (e.g., 8.8.8.8): " DNS

    # Convert subnet mask to CIDR notation if not already
    if [[ "$SUBNET" =~ ^[0-9]+\.[0-9]+\.[0-9]+\.[0-9]+$ ]]; then
        case "$SUBNET" in
            "255.255.255.0") SUBNET="/24" ;;
            "255.255.0.0") SUBNET="/16" ;;
            "255.0.0.0") SUBNET="/8" ;;
            *) echo "Unsupported subnet mask"; exit 1 ;;
        esac
    fi

    # Backup existing netplan configuration
    NETPLAN_FILE="/etc/netplan/01-netcfg.yaml"
    if [ -f "$NETPLAN_FILE" ]; then
        cp "$NETPLAN_FILE" "$NETPLAN_FILE.bak"
        echo "Backup created at $NETPLAN_FILE.bak"
    fi

    # Create new netplan configuration
    cat > "$NETPLAN_FILE" <<EOF
network:
version: 2
ethernets:
    $INTERFACE:
    dhcp4: no
    addresses:
        - $IP_ADDRESS$SUBNET
    gateway4: $GATEWAY
    nameservers:
        addresses: [$DNS]
EOF

    # Apply the configuration
    echo "Applying network configuration..."
    netplan apply

    # Verify the change
    echo "Network configuration complete. Current IP settings:"
    ip addr show $INTERFACE | grep inet

    echo "Done! If there are issues, check the configuration in $NETPLAN_FILE"
else
    echo "Skipping container removal."
fi

echo ""

##################################################

if confirm "Do you want install and enable SSH Client and Server?"; then
    # Install SSH client
    echo "Installing openssh-client..."
    apt install openssh-client -y

    # Install SSH Server
    echo "Installing openssh-server..."
    apt-get install openssh-server -y

    # Enable SSH Server
    echo "Enabling SSH..."
    systemctl enable ssh

else
    echo "Skipping installing and enabling SSH Client and Server."
fi

echo ""

##################################################

if confirm "Do you want install and enable Uncomplicated Firewall (UFW)?"; then
    # Install ufw
    echo "Installing UFW..."
    apt install ufw -y

    echo "Configuring to allow SSH through UFW..."
    ufw allow ssh
    echo "Enabling UFW..."
    ufw enable

else
    echo "Skipping installing and enabling UFW."
fi

echo ""

##################################################

if confirm "Do you want to install Docker?"; then
    # Docker
    echo "Installing and setting up Docker..."

    # Check if Docker is installed
    if ! command -v docker &> /dev/null; then
        curl -fsSL https://get.docker.com | bash -
        # test docker with: sudo docker run hello-world
    else
        echo "Docker is already installed!"
        docker --version
    fi

else
    echo "Skipping installing Docker."
fi

echo ""

##################################################

if confirm "Do you want to create additional users with sudo privilege?"; then
    
    # Make Sudo Users
    echo "Setting up additional sudo users..."
    read -p "Number of sudo users to add [0-10]: " number_of_users

    for (( i=1; i<=number_of_users; i++ ))
    do
        read -p "Enter username for user #$i: " username_user
        adduser --disabled-password --gecos "" "$username_user"
        usermod -aG sudo "$username_user"

        echo "$username_user ALL=(ALL) NOPASSWD: ALL" | tee /etc/sudoers.d/"$username_user" > /dev/null
        
        read -p "Enter Public SSH-key for ($username_user) user #$i: " public_key_user
        mkdir -p /home/"$username_user"/.ssh
        echo "$public_key_user" | sudo tee /home/"$username_user"/.ssh/authorized_keys > /dev/null
        chown -R "$username_user":"$username_user" /home/"$username_user"/.ssh
        chmod 700 /home/"$username_user"/.ssh
        chmod 600 /home/"$username_user"/.ssh/authorized_keys

    done

else
    echo "Skipping creating additional users with sudo privilege."
fi

echo ""

##################################################