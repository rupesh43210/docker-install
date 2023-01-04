#! /bin/bash

sudo apt update

sudo apt-get update
sudo apt-get install \
    ca-certificates \
    curl \
    gnupg \
    lsb-release
    
sudo mkdir -p /etc/apt/keyrings
curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo gpg --dearmor -o /etc/apt/keyrings/docker.gpg
 
 echo \
  "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/docker.gpg] https://download.docker.com/linux/ubuntu \
  $(lsb_release -cs) stable" | sudo tee /etc/apt/sources.list.d/docker.list > /dev/null
  
  sudo apt-get remove docker docker-engine docker.io containerd runc
  
 sudo apt-get update 
 sudo apt-get install docker-ce docker-ce-cli containerd.io docker-compose-plugin
 
 cd ../
 rm -r docker-install/
 
 clear 
 
 sudo apt autoremove -y
 
 echo "Docker Install Completed" 
 
 docker volume create portainer_data
 
 docker run -d -p 8000:8000 -p 9443:9443 --name portainer \
    --restart=always \
    -v /var/run/docker.sock:/var/run/docker.sock \
    -v portainer_data:/data \
    portainer/portainer-ce:latest
    
 cd ../
 rm -r docker-install/
    
 clear
 
 echo "Please visit https://localhost:9443"
