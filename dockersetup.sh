#!/bin/bash

# Update package lists
sudo apt-get update

# Install dependencies
sudo apt-get install -y ca-certificates curl gnupg lsb-release

# Add Docker GPG key and repository
sudo mkdir -p /etc/apt/keyrings
curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo gpg --dearmor -o /etc/apt/keyrings/docker.gpg
echo "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/docker.gpg] https://download.docker.com/linux/ubuntu $(lsb_release -cs) stable" | sudo tee /etc/apt/sources.list.d/docker.list > /dev/null

# Remove old versions of Docker
sudo apt-get remove -y docker docker-engine docker.io containerd runc

# Install Docker Engine and CLI
sudo apt-get update
sudo apt-get install -y docker-ce docker-ce-cli containerd.io

# Install Docker Compose (latest release)
DOCKER_COMPOSE_VERSION=$(curl -s https://api.github.com/repos/docker/compose/releases/latest | grep 'tag_name' | cut -d\" -f4)
sudo curl -L "https://github.com/docker/compose/releases/download/${DOCKER_COMPOSE_VERSION}/docker-compose-$(uname -s)-$(uname -m)" -o /usr/local/bin/docker-compose
sudo chmod +x /usr/local/bin/docker-compose

# Add current user to the Docker group, if not already added
if ! getent group docker > /dev/null; then
    sudo groupadd docker
fi
sudo usermod -aG docker $USER

# Set up Portainer only if it's not already running
if [ ! "$(docker ps -q -f name=portainer)" ]; then
    if [ "$(docker ps -aq -f status=exited -f name=portainer)" ]; then
        # Cleanup if a previous Portainer container exists and is exited
        docker rm portainer
    fi
    # Run Portainer
    docker run -d -p 8000:8000 -p 9443:9443 --name portainer --restart=always -v /var/run/docker.sock:/var/run/docker.sock -v portainer_data:/data portainer/portainer-ce:latest
fi

# Clean up
sudo apt autoremove -y
echo "Docker and Portainer CE Installation Completed"

# Reminder for group change
echo "Please log out and back in to apply Docker group changes, or start a new shell session."
