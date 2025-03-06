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
echo "Initial setup script started..."
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

# Add existing user(s) to set up sudo without password
if confirm "Do you want to setup existing user(s) to use sudo without password?"; then
    while true; do
        # Prompt for username
        echo "Enter username (or press Enter to finish):"
        read -r USERNAME

        # Check if input is empty
        if [ -z "$USERNAME" ]; then
            echo "No more users to process. Exiting..."
            break
        fi

        # Check if user exists
        if ! id "$USERNAME" >/dev/null 2>&1; then
            echo "Error: User '$USERNAME' does not exist."
            continue
        fi

        # Check if user is in sudo group
        if ! groups "$USERNAME" | grep -q "\bsudo\b"; then
            echo "User '$USERNAME' is not in sudo group. Adding them now..."
            usermod -aG sudo "$USERNAME"
            if [ $? -eq 0 ]; then
                echo "Successfully added $USERNAME to sudo group"
            else
                echo "Error: Failed to add $USERNAME to sudo group"
                continue
            fi
        else
            echo "User '$USERNAME' is already in sudo group"
        fi

        # Create sudoers file for the user
        SUDOERS_FILE="/etc/sudoers.d/$USERNAME"

        # Check if file already exists
        if [ -f "$SUDOERS_FILE" ]; then
            echo "Warning: Sudoers file for $USERNAME already exists."
            echo "Do you want to overwrite it? (y/N)"
            read -r response
            if [[ ! "$response" =~ ^[Yy]$ ]]; then
                echo "Skipping $USERNAME"
                continue
            fi
        fi

        # Write the sudoers configuration
        echo "$USERNAME ALL=(ALL) NOPASSWD:ALL" > "$SUDOERS_FILE"

        # Set correct permissions
        chmod 0440 "$SUDOERS_FILE"

        # Verify syntax of sudoers files
        if visudo -c >/dev/null 2>&1; then
            echo "Successfully configured sudo without password for $USERNAME."
        else
            echo "Error: Syntax check failed for $USERNAME, removing invalid file."
            rm "$SUDOERS_FILE"
        fi
    done

else
    echo "Skipping setup existing user(s) to use sudo without password."
fi

echo ""

##################################################

if confirm "Do you want to setup static IP for this computer?"; then

    echo "Setting up static IP for this computer..."
    # Prompt user for network interface
    echo "Available network interfaces:"
    ip link | grep -E '^[0-9]:' | awk '{print $2}' | tr -d ':'
    read -p "Enter the network interface (e.g., eth0 for wired, wlan0 for WiFi): " INTERFACE

    # Get current information
    IP=$(hostname -I | awk '{print $1}')  # Takes the first IP if multiple exist
    GATEWAY=$(ip route | grep default | awk '{print $3}')
    SUBNET_CIDR=$(ip -o -f inet addr show $INTERFACE | awk '{print $4}' | cut -d'/' -f2)
    DNS_SERVERS=$(nmcli dev show $INTERFACE | grep 'IP4.DNS' | awk '{print $2}' | tr '\n' ' ')

    # Output the results
    echo "Current Settings"
    echo "Network Interface: $INTERFACE"
    echo "IP Address: $IP"
    echo "Gateway Address: $GATEWAY"
    echo "DNS Servers: $DNS_SERVERS"

    # Prompt user for network details
    read -p "Enter the static IP address (current IP is $IP): " IP_ADDRESS
    read -p "Enter the subnet mask (e.g., 255.255.255.0 or /24): " SUBNET
    read -p "Enter the gateway address (current gateway is $GATEWAY): " GATEWAY
    read -p "Enter the DNS server (current DNS Server(s) are $DNS_SERVERS): " DNS

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
      routes:
        - to: default
          via: $GATEWAY
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
    echo ""

    # Install SSH Server
    echo "Installing openssh-server..."
    apt-get install openssh-server -y
    echo ""
    
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

    echo "Enabling UFW..."
    ufw enable

else
    echo "Skipping installing and enabling UFW."
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

if confirm "Do you want apply strict SSH rules?"; then
    
    # Disable root user SSH login
    echo "Disabling root SSH login, SSH empty passwords, and SSH password authentication (only allows SSH-keys)..."
    sudo sed -i 's/^#PermitRootLogin prohibit-password/PermitRootLogin no/g' /etc/ssh/sshd_config
    sudo sed -i 's/^#PermitEmptyPasswords no/PermitEmptyPasswords no/g' /etc/ssh/sshd_config
    sudo sed -i 's/^#PasswordAuthentication yes/PasswordAuthentication no/g' /etc/ssh/sshd_config
    # in AWS Ligthsail (debian) PasswordAuthentication is set to no by default.

    echo ""

    echo "Restarting SSH service..."
    sudo systemctl restart sshd

else
    echo "Skipping applying strict SSH rules."
fi

echo ""

##################################################

echo "Initial setup script complete!"

##################################################