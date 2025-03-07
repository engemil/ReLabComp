# Use the latest Ubuntu image from Docker Hub
FROM ubuntu:latest

# Ensure no need for user prompt when installing
ENV DEBIAN_FRONTEND=noninteractive

# Update and Upgrade
RUN apt update -y
RUN apt upgrade -y

# Essentials
RUN apt install sudo -y
RUN apt install git -y
RUN apt install usbutils -y
RUN apt install build-essential -y
RUN apt install nano -y

# Install SSH Server
RUN apt install openssh-server -y

# Install python
RUN apt install python3 -y && \
    apt install python-is-python3 -y && \
    apt install python3-pip -y
# Python module(s)
RUN apt install python3-serial -y

# Clean list
RUN rm -rf /var/lib/apt/lists/*

# Prepare SSH config
RUN mkdir -p /var/run/sshd && \
    sed -i 's/#PasswordAuthentication yes/PasswordAuthentication yes/' /etc/ssh/sshd_config

# Create labuser and set up sudo without password
ARG LABUSER_PASSWORD
RUN useradd -m -s /bin/bash labuser && \
    echo "labuser:${LABUSER_PASSWORD}" | chpasswd && \
    usermod -aG sudo labuser && \
    mkdir -p /etc/sudoers.d && \
    echo "labuser ALL=(ALL) NOPASSWD:ALL" >> /etc/sudoers.d/labuser && \
    chmod 0440 /etc/sudoers.d/labuser

# Change to labuser and set working directory
USER labuser
WORKDIR /home/labuser

# Port exposed
EXPOSE 22

# Start SSH service. Allow continuous access over SSH without stopping container
CMD ["/usr/sbin/sshd", "-D"]

