# Use the latest Ubuntu image from Docker Hub
FROM ubuntu:latest

# Ensure no need for user prompt when installing
ENV DEBIAN_FRONTEND=noninteractive

# Update and Upgrade
RUN apt-get update -y
RUN apt-get upgrade -y

# Essentials
RUN apt install sudo -y
RUN apt install git -y
RUN apt install usbutils -y
RUN apt install build-essential -y

# Install SSH Server
RUN apt install openssh-server -y


# Install python
RUN apt install python3 -y
RUN apt install python-is-python3 -y
RUN apt install python3-pip -y
# Python module(s)
RUN apt install python3-serial -y

# Clean list
RUN rm -rf /var/lib/apt/lists/*

# Port exposed
EXPOSE 22

# Create labuser and set up sudo without password
ARG LABUSER_PASSWORD
RUN useradd -m -s /bin/bash labuser && echo "labuser:${LABUSER_PASSWORD}" | chpasswd
RUN usermod -aG sudo labuser
RUN mkdir -p /etc/sudoers.d && \
    echo "labuser ALL=(ALL) NOPASSWD:ALL" >> /etc/sudoers.d/labuser


RUN mkdir /var/run/sshd
RUN sed -i 's/^#PasswordAuthentication yes/PasswordAuthentication yes/' /etc/ssh/sshd_config
RUN service ssh restart    


USER labuser
WORKDIR /home/labuser

# To allow continuous access over SSH without stopping container
CMD ["/usr/sbin/sshd", "-D"]

