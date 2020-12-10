#bin/bash

sudo apt update && sudo apt upgrade
sudo apt-get install -y zsh git vim tree
curl -fsSL https://get.docker.com -o get-docker.sh
sudo sh get-docker.sh
rm get-docker.sh
sudo group add docker
sudo usermod -aG docker $USER
sudo apt-get install docker-compose
docker run hello-world
#wget https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh
#sh install.sh
#rm install.sh
