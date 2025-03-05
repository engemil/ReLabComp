#!/bin/bash

# This is a script to quickly check your SSH keys
#
# HOW-TO USE:
# 1. Configure permissions: chmod +x sshkeycheck.sh
# 2. Execute: ./sshkeycheck.sh
#

# Check if ~/.ssh directory exists
if [ ! -d "$HOME/.ssh" ]; then
  echo "Error: ~/.ssh directory does not exist. This could mean that you have no SSH Keys."
  echo " To make a SSH Keys, use: ssh-keygen -t ed25519 -C \"my_email@example.com\""
  exit 1
fi

# Change directory to ~/.ssh
cd "$HOME/.ssh"

# List all files inside ~/.ssh directory
echo "Listing all files in ~/.ssh directory:"
ls -l

# Ask which public key the user wants to see
echo "Please enter the name of the public key file you want to see (e.g., id_rsa.pub):"
read -r pubkey # the same as e.g. cat id_ed25519.pub

# Check if the specified public key file exists
if [ ! -f "$pubkey" ]; then
  echo "Error: File '$pubkey' does not exist."
  exit 1
fi

# Display the contents of the specified public key file
echo "Contents of '$pubkey':"
cat "$pubkey"