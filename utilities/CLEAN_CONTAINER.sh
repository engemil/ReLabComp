#!/bin/bash

# This script removes containers, container images and prunes docker with the prefix.
# Each action is prompted befor executing, to ensure which of the steps you'd like to do.

# HOW-TO use:
# Change permission: chmod +x ./CLEAN_CONTAINER.sh
# Execute: ./CLEAN_CONTAINER.sh [prefix]  (defaults to "simple" if no prefix provided)

CONTAINER_PREFIX="simple"

echo "Starting CLEAN_CONTAINER.sh script for removing containers, container images, and pruning the system..."

if [ $# -gt 0 ]; then      # Check if any arguments were provided
    CONTAINER_PREFIX="$1"  # Update with first argument if provided
else
    echo "No prefix provided, using default '${CONTAINER_PREFIX}'."
    echo "Usage: $0 [prefix]"
    echo "Example: $0 dev  # This would clean containers and images starting with 'dev'"
fi

# Function to ask for confirmation
confirm() {
    while true; do
        read -p "$1 (y/n): " answer
        case $answer in
            [Yy]* ) return 0;;
            [Nn]* ) return 1;;
            * ) echo "Please answer yes (y) or no (n).";;
        esac
    done
}

# Function to stop and remove containers
remove_containers() {
    containers=$(docker ps -a --filter "name=${CONTAINER_PREFIX}" --format "{{.ID}}")
    if [ -z "$containers" ]; then
        echo "No containers found starting with '${CONTAINER_PREFIX}'."
    else
        echo "Stopping and removing all our devcontainers starting with '${CONTAINER_PREFIX}'."
        for container in $containers; do
            echo "Stopping container: $container"
            docker stop $container
            echo "Removing container: $container"
            docker rm $container
        done
    fi
}

# Function to remove images
remove_images() {
    images=$(docker images --filter=reference='${CONTAINER_PREFIX}*' --format "{{.ID}}")
    if [ -z "$images" ]; then
        echo "No images found starting with '${CONTAINER_PREFIX}'."
    else
        echo "Removing images starting with '${CONTAINER_PREFIX}'."
        for image in $images; do
            echo "Removing image: $image"
            docker rmi $image
        done
    fi
}

# Function to prune docker
prune_docker() {
    echo "Pruning Docker system..."
    docker system prune -a --volumes
}

# Execute the functions with confirmation
if confirm "Do you want to remove containers with prefix '${CONTAINER_PREFIX}'?"; then
    remove_containers
else
    echo "Skipping container removal."
fi

if confirm "Do you want to remove images with prefix '${CONTAINER_PREFIX}'?"; then
    remove_images
else
    echo "Skipping image removal."
fi

if confirm "Do you want to prune the Docker system? (This removes all unused data)"; then
    prune_docker
else
    echo "Skipping Docker system prune."
fi

echo "Operation completed."