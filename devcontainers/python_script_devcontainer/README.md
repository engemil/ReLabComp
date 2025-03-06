# Python Script Devcontainer

Python script environment. Setup for adding running python scripts interacting with hardware connected to host computer, from container.

## HOW-TO Run over terminal (without VS Code)

- Change current directory: `cd /ReLabComp/devcontainers/python_script_devcontainer`
- Spin up container: `sudo docker compose -f .devcontainer/docker-compose.yml up -d`
    - To stop container: `sudo docker compose -f .devcontainer/docker-compose.yml down`
    - To access container (from host computer): `sudo docker exec -it labcontainer-001 /bin/bash`
- If you want to access this container via SSH from another computer:
    - From linux: `ssh -o StrictHostKeyChecking=no -o UserKnownHostsFile=/dev/null -p 2222 labuser@<HOST-COMPUTER-IP>`
    - From Windows: `ssh -o StrictHostKeyChecking=no -o UserKnownHostsFile=NUL -p 2222 labuser@<HOST-COMPUTER-IP>`
    - NB! Maybe you need to enable port 2222 on host computer: `./ReLabComp/utilities/host_utilities/setup_ufw_ports.sh`
    - **NB!** Problematic, need to access the container and run the following: `sudo service ssh restart`
        - Note: Tried to add it to the `Dockerfile`, but doesn't seem to work.

## HOW-TO Run from VS Code

TODO: Add notes here




