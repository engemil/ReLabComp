#!/bin/bash

#
# Script for starting container
#
# HOW-TO-USE:
# 1. Change permission: sudo chmod +x ./start.sh
# 2. Execute script: sudo ./start.sh
#
# NOTE: If you do not have sudo installed, I assume you are
#       using a root user and do not need sudo for this script.
#

##################################################

docker compose -f .devcontainer/docker-compose.yml up -d
