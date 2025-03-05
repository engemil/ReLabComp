# Use the latest Ubuntu image from Docker Hub
FROM ubuntu:latest

# Update and Upgrade
RUN apt update 
RUN apt upgrade -y

# Install git
RUN apt install git -y

# Install python
RUN apt install python3 -y
RUN apt install python-is-python3 -y
RUN apt install python3-pip -y
# Python module(s)
RUN apt install python3-serial -y

# Install USB utilities
RUN apt install usbutils -y