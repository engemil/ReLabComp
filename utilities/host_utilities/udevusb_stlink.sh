#!/bin/bash

# HOW-TO use:
# 1. Configure permissions: chmod +x ./udevusb_stlink.sh
# 2. Execute: ./udevusb_stlink.sh

# Step 1: Create udev rule
echo "Creating udev rule..."
echo '# STMicroelectronics ST-LINK/V2-1
ATTRS{idVendor}=="0483", ATTRS{idProduct}=="374b", MODE="0666"' | sudo tee /etc/udev/rules.d/usb-devices.rules

# Step 2: Reload udev rules
echo "Reloading udev rules..."
sudo udevadm control --reload-rules
sudo udevadm trigger

# Step 3: Add user to plugdev group
echo "Adding current user to plugdev group..."
sudo usermod -aG plugdev $USER

# Inform the user to log out and back in
echo "Please log out and log back in to apply the group changes."

# Done
echo "Script completed. You should now have the necessary permissions to access the USB device."

# Optional: Check device access (uncomment the lines below if needed)
echo "Checking device access..."
ls -l /dev/bus/usb/$(lsusb | grep '0483:374b' | awk '{print $2}')/$(lsusb | grep '0483:374b' | awk '{print $4}' | tr -d :)

# Extra
echo "Check with 'lsusb' to see if the device matches with the ID: 0483:374b"

# TODO:
# - Add options
# - Add the possibility to choose, with use of lsusb?