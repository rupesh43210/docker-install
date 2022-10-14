#! /bin/bash

sudo apt update

rm dockersetup.sh

sudo apt-get install -y \
    ca-certificates \
    curl \
    gnupg \
    lsb-release
    
 sudo mkdir -p /etc/apt/keyrings
 curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo gpg --dearmor -o /etc/apt/keyrings/docker.gpg
 
 echo \
  "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/docker.gpg] https://download.docker.com/linux/ubuntu \
  $(lsb_release -cs) stable" | sudo tee /etc/apt/sources.list.d/docker.list > /dev/null
  
 sudo apt-get update
 sudo apt-get install -y docker-ce docker-ce-cli containerd.io docker-compose-plugin
 
 cd ../
 rm -r docker-install/
 
 clear 
 
 sudo apt autoremove -y
 
 echo "Docker Install Completed" 
 
 mkdir ~/wordpress && cd ~/wordpress
 
 docker run -e MYSQL_ROOT_PASSWORD=wordpress -e MYSQL_DATABASE=wordpress --name wordpressdb -v "$PWD/database":/var/lib/mysql -d mariadb:latest
 
 docker pull wordpress
 
 docker run -e WORDPRESS_DB_USER=root -e WORDPRESS_DB_PASSWORD=wordpress --name wordpress --link wordpressdb:mysql -p 8090:80 -v "$PWD/html":/var/www/html -d wordpress
 
 #cd ../
 
 #rm -r docker-install/
