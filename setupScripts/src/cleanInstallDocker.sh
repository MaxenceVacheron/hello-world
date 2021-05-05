#bin/bash

curl -fsSL https://get.docker.com -o get-docker.sh
sh get-docker.sh
apt-get -y install docker-compose
#sudo group add docker
#sudo usermod -aG docker $USER
#sudo apt-get -y install docker-compose
#docker run hello-world

