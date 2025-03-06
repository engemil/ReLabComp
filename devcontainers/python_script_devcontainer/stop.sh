#!/bin/bash

#
# Script for stopping container
#
# HOW-TO-USE:
# 1. Change permission: sudo chmod +x ./stop.sh
# 2. Execute script: sudo ./stop.sh
#
# NOTE: If you do not have sudo installed, I assume you are
#       using a root user and do not need sudo for this script.
#

##################################################

sudo docker compose -f .devcontainer/docker-compose.yml down
