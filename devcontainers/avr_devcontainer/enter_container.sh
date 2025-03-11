#!/bin/bash

#
# Script to enter container
#
# HOW-TO-USE:
# 1. Change permission: sudo chmod +x ./enter_container.sh
# 2. Execute script: sudo ./enter_container.sh
#
# NOTE: If you do not have sudo installed, I assume you are
#       using a root user and do not need sudo for this script.
#

##################################################

docker exec -it labcontainer-003 /bin/bash
