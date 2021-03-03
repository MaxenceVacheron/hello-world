#bin/bash

sudo apt-get update -y && sudo apt-get upgrade -y
sudo apt-get install -y zsh git vim tree
curl -fsSL https://get.docker.com -o get-docker.sh
sudo sh get-docker.sh
sudo group add docker
sudo usermod -aG docker $USER
sudo apt-get -y install docker-compose
docker run hello-world

