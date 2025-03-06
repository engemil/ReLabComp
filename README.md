# ReLabComp

A collection of scripts and configs for setting up an Ubuntu computer as a remote lab computer

Operative System: `Ubuntu 24.04.2 LTS`



Files

- **devcontainers**: Collection of devcontainers that can be used
- **extra_notes**
    - **create_ssh_key**
    - **ubuntu_cli**
- **ubuntu_host_setup**: Script(s) for setting up and configuring the host computer (with Ubuntu) as a remote lab computer
- **utilities**: Utility scripts


# TODOs

- FIX problem related to needing to `sudo service ssh restart` inside container before doing direct connection with SSH. For the "python_script_devcontainer"
- FIX bug with "identify_port.sh" script. Doesn't seem to detect the "/dev/ttyACMx" port for arduino.

