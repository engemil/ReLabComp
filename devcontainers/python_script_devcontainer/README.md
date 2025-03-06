# Python Script Devcontainer

Python script environment. Setup for adding running python scripts interacting with hardware connected to host computer, from container.

## HOW-TO Run over terminal (without VS Code)

- Change current directory: `cd /ReLabComp/devcontainers/python_script_devcontainer`
- Spin up container: `sudo docker compose -f .devcontainer/docker-compose.yml up -d`
    - To stop container: `sudo docker compose -f .devcontainer/docker-compose.yml down`
    - To access container (from host computer): `sudo docker exec -it labcontainer-001 /bin/bash`
- If you want to access this container via SSH from another computer: `ssh labuser@<HOST-COMPUTER-IP> -p 2222`
    - NB! Check which ports are open on host computer?!
        - Add port 2222 to ufW: `sudo ufw allows 2222`
        - Open ports on ufw: `sudo ufw reload`

## HOW-TO Run from VS Code

TODO: Add notes here


